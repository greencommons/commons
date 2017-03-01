class ApplicationSerializer < ActiveModel::Serializer
  link :self do
    href send("api_v1_#{object.class.to_s.downcase}_url", object)
  end
end
