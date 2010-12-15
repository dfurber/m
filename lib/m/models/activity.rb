class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, :polymorphic => true
  validates_presence_of :user_id
  
  after_save :update_counter_on_user
  
  scope :of_item_type, lambda {|type|
    {:conditions => ["activities.item_type = ?", type]}
  }
  scope :since, lambda { |time|
    {:conditions => ["activities.created_at > ?", time] }
  }
  scope :before, lambda {|time|
    {:conditions => ["activities.created_at < ?", time] }    
  }
  scope :recent, :order => "activities.created_at DESC"
  scope :by_users, lambda {|user_ids|
    {:conditions => ['activities.user_id in (?)', user_ids]}
  }
  
  
  def update_counter_on_user
    if user && user.class.column_names.include?('activities_count')
      user.update_attribute(:activities_count, Activity.by(user) )
    end
  end
  
  def self.by(user)
    Activity.count(:all, :conditions => ["user_id = ?", user.id])
  end
    
end
