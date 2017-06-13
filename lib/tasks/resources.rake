namespace :resources do
  desc 'Format content and metadata dates for elasticsearch'
  task clean_resources: :environment do
    Resource.all.each do |resource|
      resource.content = '' unless resource.content.is_a?(String)

      if resource.metadata['date'] == '' || resource.metadata['date'].blank?
        resource.metadata['date'] = nil
      end

      if resource.metadata['date']
        begin
          date = Date.parse(resource.metadata['date'])
          resource.metadata['date'] = date
        rescue StandardError => e
          p e
        end
      end

      resource.save if resource.changed?
    end
  end

  task transfer_content: :environment do
    Resource.find_each.each do |resource|
      ap "Transferring content for resource #{resource.id}"
      next unless resource.content.is_a?(String)
      resource.long_content = resource.content
      resource.content = {}
      resource.save!
    end
  end
end
