require 'rails_helper'

describe Mutations::CreateUser do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($object: UserAttributes!) {
        createUser(
          input: {
            object: $object
          }
        ){
          user {
            id
            name
            email
          }
        }
      }
    GRAPHQL
  }

  context 'nomally' do
    it 'create an item and return object' do
      object = {
        name: "ユーザー1",
        email: "info@toyasoft.com"
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { object: object })
      expect(result.dig('data', 'createUser', 'item')).not_to be_blank
      expect(User.count).to eq 1
      expect(User.first).to have_attributes(
        name: 'ユーザー1',
        email: "info@toyasoft.com"
      )
    end
  end

end
