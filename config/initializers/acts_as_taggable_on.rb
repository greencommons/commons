ActsAsTaggableOn.remove_unused_tags = true
ActsAsTaggableOn.force_lowercase = true
ActsAsTaggableOn::Tagging.belongs_to :taggable, polymorphic: true, touch: true
