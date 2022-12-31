require 'rails_helper'

describe Mutations::DeleteItem do
  let(:query_string) {
    <<-GRAPHQL
      mutation($id: ID!) {
        deleteItem(
          input: {
            id: $id
          }
        ){
          item {
            id
          }
        }
      }
    GRAPHQL
  }

  context 'nomally' do
    let(:item) { create(:item, group: group) }

    it 'delete an item' do
      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { id: item.id })
      item.reload

      expect(item.discarded?).to eq true
      expect(Item.kept.ids).not_to include item.id
      expect(result.dig('data', 'deleteItem', 'item', 'id')).to eq item.id.to_s
    end
  end

  context 'if the item associated group in the same company' do
    let!(:user_in_different_company) { create(:user, group: group_in_different_company) }
    let!(:group_in_different_company) { create(:group) }
    let(:user_in_the_same_company) { create(:user, group: group_in_the_same_company) }
    let(:group_in_the_same_company) { create(:group) }
    let(:item) { create(:item, group: group_in_the_same_company) }

    it 'delete an item' do
      result = WebSchema.execute(query_string, context: { current_user: user_in_the_same_company }, variables: { id: item.id })
      item.reload

      expect(item.discarded?).to eq true
      expect(Item.kept.ids).not_to include item.id
      expect(result.dig('data', 'deleteItem', 'item', 'id')).to eq item.id.to_s
    end
  end

  context 'if the item associated group in different company' do
    let!(:user_in_the_same_company) { create(:user, group: group_in_the_same_company) }
    let!(:group_in_the_same_company) { create(:group) }
    let(:user_in_different_company) { create(:user, group: group_in_different_company) }
    let(:group_in_different_company) { create(:group) }
    let(:item) { create(:item, group: group_in_the_same_company) }

    it 'raise error not authorized' do
      result = WebSchema.execute(query_string, context: { current_user: user_in_different_company }, variables: { id: item.id })
      item.reload

      expect(item.discarded?).to eq false
      expect(Item.kept.ids).to include item.id
      expect(result.dig('data', 'deleteItem')).to eq nil
      expect(result.dig('errors', 0, 'message')).to eq "not authorized to delete item"
    end
  end

  context 'if the item is already in use' do
    let(:user) { create(:user, group: group) }
    let(:item) { create(:item, group: group) }
    let(:group) { create(:group) }
    let!(:opportunity) { create(:opportunity, item: item, user: user) }

    it 'raise error already in use' do
      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { id: item.id })
      item.reload

      expect(item.discarded?).to eq false
      expect(Item.kept.ids).to include item.id
      expect(result.dig('data', 'deleteItem')).to eq nil
      expect(result.dig('errors', 0, 'message')).to eq "#{item.name} を使用している案件があります。削除する前にご確認をお願いします。"
    end
  end

  context 'if the non-exists ID was specified' do
    let(:user) { create(:user, group: group) }
    let(:group) { create(:group) }
    let!(:item) { create(:item, group: group) }

    it 'raise error not found' do
      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { id: 0 })

      expect(result.dig('data', 'deleteItem')).to eq nil
      expect(result.dig('errors', 0, 'message')).to eq 'item not found with id:0'
    end
  end

  context 'if the items is already deleted' do
    let(:user) { create(:user, group: group) }
    let(:group) { create(:group) }
    let(:item) { create(:item, group: group) }

    it 'raise error not found' do
      item.discard!

      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { id: 0 })

      expect(result.dig('data', 'deleteItem')).to eq nil
      expect(result.dig('errors', 0, 'message')).to eq 'item not found with id:0'
    end
  end
end
