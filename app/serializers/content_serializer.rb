class ContentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :blob_id
end
