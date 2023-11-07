require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#new' do
    it '正常なレスポンスを返すこと' do
      get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'ログイン成功' do
      let!(:user) {FactoryBot.create(:user)}

      context 'remember機能オン' do
        before do
          post :create, params: {
            session: {
              email: user.email,
              password: user.password,
              remember_me: '1'
            }
          }
        end
        it 'ログインされていること' do
          expect(is_logged_in?).to be_truthy
        end
        it 'remember機能が実行されていること' do
          user = User.find_by(id: session[:user_id])
          expect(user.remember_digest).not_to be_nil
          expect(response.cookies["user_id"]).not_to be_nil
          expect(response.cookies["remember_token"]).not_to be_nil
        end
        it 'ログイン後にforwarding_urlまたはルートページにリダイレクトされていること' do
          forwarding_url = session[:forwarding_url]
          expect(response).to redirect_to(forwarding_url ? forwarding_url : root_path)
        end
      end

      context 'remember機能オフ' do
        before do
          post :create, params: {
            session: {
              email: user.email,
              password: user.password,
              remember_me: '0'
            }
          }
        end
        it 'remember機能が実行されていないこと' do
          expect(user.remember_digest).to be_nil
          expect(response.cookies["user_id"]).to be_nil
          expect(response.cookies["remember_token"]).to be_nil
        end
      end

    end
    context 'ログイン失敗' do
      before do
        FactoryBot.create(:user)
        post :create, params: {
          session: {
            email: 'taro@example.com',
            password: ''
          }
        }
      end
      it 'flashメッセージが表示されていること' do
        expect(flash[:danger]).to include('emailまたはパスワードが間違っています。')
      end
      it 'ルートページにリダイレクトされていること' do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe '#destroy' do
    context 'ログイン状態' do
      let!(:user) {FactoryBot.create(:user)}
      before do
        log_in user
        remember user
        delete :destroy, params: {
          id: user.id
        }
      end
      it 'ログアウトされること' do
        expect(session[:user_id]).to be_falsey
        expect(response.cookies["user_id"]).to be_falsey
        expect(response.cookies["remember_token"]).to be_falsey
      end
      it 'flashメッセージが表示されていること' do
        expect(flash[:success]).to include('ログアウトしました。')
      end
      it 'ルートページにリダイレクトされていること' do
        expect(response).to redirect_to(root_path)
      end
    end
  end


end