require 'rails_helper'

describe Types::QueryType do
  let!(:user) { create(:user) }

  describe 'current_user' do
    let!(:query_string) {
      <<-GRAPHQL
        query {
          currentUser {
            email
            point
            id

          }
        }
      GRAPHQL
    }

    context '通常時' do
      it 'ユーザーオブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'currentUser')).to eq(
          'id' => user.id.to_s,
          'email' => user.email,
          'point' => user.point
        )
      end
    end
    context '未ログイン時' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string)
        expect(result.dig('data', 'currentUser')).to be_nil
        expect(result.dig('errors', 0, 'message')).to include "認証エラーです"
      end
    end
 
  end
end
