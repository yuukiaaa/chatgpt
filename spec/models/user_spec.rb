require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  subject {@user.valid?}

  describe 'nameカラムのバリデーションのテスト' do
    context 'presenceのテスト' do
      it 'nilはエラーになること' do
        @user.name = nil
        is_expected.to eq(false)
      end
      it '空白文字はエラーになること' do
        @user.name = ' '
        is_expected.to eq(false)
      end
    end
    context 'uniquenessのテスト' do
      it '同一の名前はエラーになること' do
        name = "unique"
        user = FactoryBot.create(:user, name: name)
        @user = FactoryBot.build(:user, name: name)
        is_expected.to eq(false)
      end
    end
    context 'lengthのテスト' do
      it '10字以内であること' do
        @user.name = 'a' * 11
        is_expected.to eq(false)
      end
    end
  end

  describe 'emailカラムのバリデーションのテスト' do
    context 'presenceのテスト' do
      it 'nilはエラーになること' do
        @user.email = nil
        is_expected.to eq(false)
      end
      it '空白文字はエラーになること' do
        @user.email = ' '
        is_expected.to eq(false)
      end
    end
    context 'uniquenessのテスト' do
      it '同一メールアドレスの登録はエラーになること' do
        email = 'test@test.com'
        user = FactoryBot.create(:user, email: email)
        @user = FactoryBot.build(:user, email: email)
        is_expected.to eq(false)
      end
    end
    context 'lengthのテスト' do
      it '255字以内であること' do
        @user.email = "a" * 256
        is_expected.to eq(false)
      end
    end
  end

  describe 'passwordのテスト' do
    context 'presenceのテスト' do
      it 'nilはエラーになること' do
        @user.password = nil
        is_expected.to eq(false)
      end
      it '空白文字はエラーになること' do
        @user.password = ' ' * 6
        is_expected.to eq(false)
      end
    end
    context 'lengthのテスト' do
      it '6文字以上あること' do
          @user.password = "a" * 5
          is_expected.to eq(false)
      end
    end
  end

  describe 'before_saveのテスト' do
    context 'emailのdowncaseのテスト' do
      it 'emailを小文字に変換してからデータベースに保存すること' do
        email = 'TEST@TEST.COM'
        user = FactoryBot.create(:user, email: email)
        expect(user.email).to eq(email.downcase)
      end
    end
  end

  describe 'User.digestのテスト' do
    it 'インプット文字列が変換されること' do
      text = 'example'
      expect(User.digest(text).to_s).not_to eq(text)
    end
  end

  describe 'User.new_tokenのテスト' do
    it 'トークンが発行されること' do
      expect(User.new_token).not_to be_nil
    end
  end

  describe '#remember' do
    it 'remember_digestカラムが更新されること' do
      @user.remember
      expect(@user.remember_digest).not_to be_nil
    end
  end

  describe '#authenticated?' do
    it 'remember_digestカラムがnilの場合はfalseが返ること' do
      @user.remember
      @user.forget
      expect(@user.authenticated?(@user.remember_token)).to be_falsey
    end
    it 'クッキーが認証されること' do
      @user.remember
      expect(@user.authenticated?(@user.remember_token)).to be_truthy
    end
  end

  describe '#forget' do
    it 'remember_digestカラムがnilになること' do
      @user.remember
      @user.forget
      expect(@user.remember_digest).to be_nil
    end
  end


end
