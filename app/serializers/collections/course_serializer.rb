module Collections
  # Serializer for collections of courses (a.k.a index)
  class CourseSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :thumbnail_blob_id
  end
end
