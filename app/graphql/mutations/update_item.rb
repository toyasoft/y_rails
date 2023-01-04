module Mutations
  class UpdateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :id, ID, required: true
    argument :name, String, required: true
    argument :price, Integer, required: true

    def resolve(**args)
      raise CustomError::Unauthorized if context[:current_admin].nil? && context[:current_user].nil?
      website = Website.find(args[:id])
      website.update!(
        name: args[:name].nil? ? website.name : args[:name],
        title: args[:title].nil? ? website.title : args[:title],
        domain: args[:domain].nil? ? website.domain : args[:domain],
        hostname: args[:hostname].nil? ? website.hostname : args[:hostname],
        user_id: args[:user_id].nil? ? website.user_id : args[:user_id],
        password: args[:password].nil? ? '' : args[:password],
      )
      return {
        website: website,
        errors: []
      }
    end
  end
end
