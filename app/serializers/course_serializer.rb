class CourseSerializer < ActiveModel::Serializer
  has_many :contents

  attributes :id, :title, :description, :thumbnail_blob_id
end
