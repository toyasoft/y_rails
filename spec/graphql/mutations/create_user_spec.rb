require 'rails_helper'

describe Mutations::CreateUser do
  let!(:query_string) {
    <<-GRAPHQL
      mutation($email: String! $password: String!) {
        createUser(
          input: {
            email: $email,
            password: $password
          }
        ){
          user {
            email
          }
        }
      }
    GRAPHQL
  }

  context '通常時' do
    it 'ユーザーオブジェクトを返す' do
      object = {
        email: "test@toyasoft.com",
        password: "1234asdfqWer!"
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).not_to be_blank
      expect(User.count).to eq 1
      expect(User.first).to have_attributes(
        email: "test@toyasoft.com"
      )
    end
  end
  context 'メールアドレスが空の場合' do
    it 'エラーを返す' do
      object = {
        email: nil,
        password: "1234asdfqWer!"
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Variable $email of type String! was provided invalid value')
    end
  end
  context 'メールアドレスのフォーマットが正しくない場合' do
    it 'エラーを返す' do
      object = {
        email: "example",
        password: "1234asdfqWer!"
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Validation failed: Email is invalid')
    end
  end
  context 'メールアドレスが256文字以上の場合' do
    it 'エラーを返す' do
      object = {
        email: "test@" + "a" * 256 + ".com",
        password: "1234asdfqWer!"
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Validation failed: Email is too long (maximum is 255 characters)')
    end
  end
  context 'メールアドレスが重複している場合' do
    let!(:user) { create(:user, email: "test@toyasoft.com") }
    it 'エラーを返す' do
      
      object = {
        email: "test@toyasoft.com",
        password: "1234asdfqWer!"
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Validation failed: Email has already been taken')
    end
  end
  context 'パスワードが空の場合' do
    it 'エラーを返す' do
      object = {
        email: "test@toyasoft.com",
        password: nil
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createUser', 'user')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq('Variable $password of type String! was provided invalid value')
    end
  end
  context 'パスワードが7文字以下の場合' do
    it 'エラーを返す' do

    end
  end
  context 'パスワードが21文字以上の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'パスワードが必要文字を含まない場合' do
    it 'エラーを返す' do
      
    end
  end

end
