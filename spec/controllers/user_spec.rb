require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user){FactoryBot.create(:user)}

  describe '#show' do
    it '正常なレスポンスを返すこと' do
      get :show, params: {id: user.id} 
      expect(response).to be_successful
    end

    it 'ステータスコード200を返すこと' do
      get :show, params: {id: user.id}
      expect(response.status).to eq(200)
    end
  end

  describe '#new' do
    it '正常なレスポンスを返すこと' do
      get :new
      expect(response).to be_successful
    end

    it 'ステータスコード200を返すこと' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    context 'ユーザ作成失敗の場合' do
      let(:post_invalid_value) {
        post :create, params: {
          user: {
            name: '',
            email: '',
            password: ''
          }
        }
      }
      it 'ユーザを作成できないこと' do
        expect{post_invalid_value}.not_to change{User.count}
      end
      it 'フラッシュが表示されること' do
        post_invalid_value
        expect(flash[:danger]).to include('アカウント登録に失敗しました。')
      end
      it 'サインアップ画面にリダイレクトされること' do
        post_invalid_value
        expect(response).to redirect_to(action: "new")
      end
    end

    context 'ユーザ作成成功の場合' do
      it '正常にユーザを作成できること' do
        expect{
          post :create, params: {
            user: {
              name: 'taro',
              email: 'taro@example.com',
              password: 'taroexample'
            }
          }
        }.to change{User.count}.by(1)
      end
      it 'ユーザ作成後にユーザでセッションログインすること' do
        post :create, params: {
          user: {
            name: 'taro',
            email: 'taro@example.com',
            password: 'taroexample'
          }
        }
        expect(is_logged_in?).to be_truthy
      end
      it 'ユーザ作成後にユーザ詳細ページにリダイレクトされていること' do
        post :create, params: {
          user: {
            name: 'taro',
            email: 'taro@example.com',
            password: 'taroexample'
          }
        }
        expect(response).to redirect_to(User.last)
      end
    end
  end

  shared_examples 'logged_in_user' do
    it 'セッションにリダイレクト前のurlを保存していること' do
      expect(session[:forwarding_url]).to eq(request.get? ? request.original_url : nil)
    end
    it 'フラッシュメッセージが出ること' do
      expect(flash[:danger]).to include("ログインしてください。")
    end
    it 'ログインページにリダイレクトされること' do
      expect(response).to redirect_to new_session_path
    end
  end

  shared_examples 'correct_user' do
    it 'フラッシュメッセージが出ること' do
      expect(flash[:danger]).to include("編集したいアカウントでログインしてください。")
    end
    it 'ルートページにリダイレクトされること' do
      expect(response).to redirect_to root_path
    end
  end


  describe '#edit' do
    context 'ユーザがログイン状態' do
      context '自身のアカウント情報を編集' do
        before do
          log_in user
          get :edit, params: {id: user.id}
        end
        it 'ステータス200が返ること' do
          expect(response.status).to be(200)
        end
      end
      context '他人のアカウント情報を編集' do
        let!(:other_user){FactoryBot.create(:user)}
        before do
          log_in user
          get :edit, params: {id:other_user.id}
        end
        it_behaves_like 'correct_user'
      end
    end

    context 'ユーザが非ログイン状態' do
      before do
        get :edit, params: {id: user.id}
      end
      it_behaves_like 'logged_in_user'
    end
  end

  describe '#update' do
    context 'ユーザがログイン状態' do
      context '自身のアカウント情報を編集' do
        context 'ユーザ情報更新に成功' do
          before do
            log_in user
            patch :update, params: {
              id: user.id,
              user: {
                name: 'taro',
                email: 'taro@taro.test',
                password: 'taroexample',
                password_confirmation: 'taroexample'
              }
            }
          end
          it 'フラッシュメッセージが表示されること' do
            expect(flash[:success]).to include("ユーザー情報を更新しました。")
          end
          it 'ユーザ詳細ページにリダイレクトされること' do
            expect(response).to redirect_to user_path(user)
          end
        end
      end

      context '他人のアカウント情報を編集' do
        let(:other_user){FactoryBot.create(:user)}
        before do
          log_in user
          patch :update, params: {
            id: other_user.id,
            user: {
              name: 'taro',
              email: 'taro@taro.test',
              password: 'taroexample',
              password_confirmation: 'taroexample'
            }
          }
        end
        it_behaves_like 'correct_user'
      end
      
      context 'ユーザ情報更新に失敗' do
        before do
          log_in user
          patch :update, params: {
            id: user.id,
            user: {
              name: '',
              email: '',
              password: '',
              password_confirmation: 'a'
            }
          }
        end
        it 'フラッシュメッセージが表示されること' do
          expect(flash[:danger]).to include("ユーザー情報を更新できませんでした。")
        end
        it 'ユーザ詳細ページにリダイレクトされること' do
          expect(response).to redirect_to user_path(user)
        end
      end
    end

    context 'ユーザが非ログイン状態' do
      before do
        patch :update, params: {
          id: user.id,
          user: {
            name: 'taro',
            email: 'taro@taro.test',
            password: 'taroexample',
            password_confirmation: 'taroexample'
          }
        }
      end
      it_behaves_like 'logged_in_user'
    end
  end

  describe '#destroy' do
    let(:delete_request) {delete :destroy, params: {id: user.id}}
    context 'ユーザがログイン状態' do
      context '自身のアカウントを削除' do
        before do
          session[:user_id] = user.id
        end
        it '正常に削除できること' do   
          expect{delete_request}.to change{User.count}.by(-1)
        end
        it 'フラッシュメッセージが表示されること' do
          delete_request
          expect(flash[:success]).to include('アカウントを削除しました。')
        end
        it '削除後はトップページに戻ること' do
          delete_request
          expect(response).to redirect_to(controller: "tops", action: "index")
        end
      end

      context '他人のアカウントを削除' do
        let!(:another_user) {FactoryBot.create(:user)}
        before do
          session[:user_id] = another_user.id
        end
        context 'correct_user' do
          before do
            delete_request
          end
          it_behaves_like 'correct_user'
        end
        it '削除が行えないこと' do
          expect{delete_request}.not_to change{User.count}
        end
      end

    end

    context 'ユーザが非ログイン状態' do
      context'logged_in_user' do
        before do
          delete_request
        end
        it_behaves_like 'logged_in_user'
      end
      it '削除が行えないこと' do
        expect{delete_request}.not_to change{User.count}
      end
    end
  end
end
