require 'rails_helper'

describe Types::QueryType do
  let!(:group) { create(:group) }
  let!(:group_in_the_same_company) { create(:group, company: group.company) }
  let!(:group_in_different_company) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:user) { create(:user, group: group) }
  let!(:account_in_the_same_group) { create(:user, group: group) }
  let!(:account_in_the_same_company) { create(:user, group: group_in_the_same_company) }
  let!(:account_in_the_different_company) { create(:user, group: group_in_different_company) }

  describe 'user' do
    let!(:query_string) {
      <<-GRAPHQL
        query($id: ID!) {
          user(id: $id) {
            id
            name
            price
            items {
              id
              name
              point
            }
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it 'ユーザーオブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: user.id })
        expect(result.dig('data', 'user')).to eq(
          'id' => user.id.to_s,
          'name' => user.name,
          'price' => user.price
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
