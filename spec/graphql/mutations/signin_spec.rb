require 'rails_helper'

describe Mutations::Signin do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($email: String! $password: String!) {
        signin(
          input: {
            email: $email,
            password: $password
          }
        ){
          user {
            email
          }
          userToken
        }
      }
    GRAPHQL
  }

  context '通常時' do
    
    it 'ユーザーオブジェクトを返す' do
      object = {
        email: user.email,
        password: user.password
      }
      result = WorkspaceSchema.execute(query_string, variables: object)
      expect(result.dig('data', 'signin', 'user')).not_to be_blank
      expect(result.dig('data', 'signin', 'user')).to eq(
        'email' => user.email,
      )
    end
    it 'ユーザートークンを返す' do

    end
  end
  context 'ユーザーが存在しない場合' do
    it 'エラーを返す' do
      object = {
        email: "nouser@toyasoft.com",
        password: user.password
      }
      result = WorkspaceSchema.execute(query_string, variables: object)
      expect(result.dig('data', 'signin', 'user')).to be_blank
      expect(result.dig('data', 'signin', 'userToken')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('認証エラーです')
    end
  end
  context 'パスワードが間違えている場合' do
    it 'エラーを返す' do
      object = {
        email: user.email,
        password: "wrongpass"
      }
      result = WorkspaceSchema.execute(query_string, variables: object)
      expect(result.dig('data', 'signin', 'user')).to be_blank
      expect(result.dig('data', 'signin', 'userToken')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('認証エラーです')
    end
  end
  context 'メールアドレスが空の場合' do
    it 'エラーを返す' do
      object = {
        email: nil,
        password: user.password
      }
      result = WorkspaceSchema.execute(query_string, variables: object)
      expect(result.dig('data', 'signin', 'user')).to be_blank
      expect(result.dig('data', 'signin', 'userToken')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Variable $email of type String! was provided invalid value')
    end
  end
  context 'パスワードが空の場合' do
    it 'エラーを返す' do
      object = {
        email: user.email,
        password: nil
      }
      result = WorkspaceSchema.execute(query_string, variables: object)
      expect(result.dig('data', 'signin', 'user')).to be_blank
      expect(result.dig('data', 'signin', 'userToken')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Variable $password of type String! was provided invalid value')
    end
  end


end
