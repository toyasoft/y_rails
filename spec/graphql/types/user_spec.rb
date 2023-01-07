require 'rails_helper'

describe Types::QueryType do
  let!(:user) { create(:user) }

  describe 'user' do
    let!(:query_string) {
      <<-GRAPHQL
        query($id: ID!) {
          user(id: $id) {
            id
            email
            point
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it 'ユーザーオブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: user.id })
        expect(result.dig('data', 'user')).to eq(
          'id' => user.id.to_s,
          'email' => user.email,
          'point' => user.point
        )
      end
    end
    context 'ユーザーIDが無効の場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'user')).to be_nil
      end
    end
    context 'ユーザーが存在しない場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'user')).to be_nil
      end
    end

  end
end
