class ApplicationSerializer < ActiveModel::Serializer
  link :self do
    href url_for(object)
  end
end
