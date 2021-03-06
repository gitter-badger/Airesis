class PartecipationRole < ActiveRecord::Base
  
  PORTAVOCE=2
  MEMBER=1
  
  has_many :group_partecipations, :class_name => 'GroupPartecipation'
  has_many :users,:through => :group_partecipations, :class_name => 'User'
  has_many :action_abilitations, :class_name => 'ActionAbilitation'    
  belongs_to :partecipation_roles, :class_name => 'PartecipationRole', :foreign_key => :parent_partecipation_role_id
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  
  scope :common, { :conditions => {:group_id => nil }}
  
  validates_uniqueness_of :name, :scope => :group_id
  
  validates_presence_of :name, :description
  
  before_destroy :change_partecipation_roles
  
  def change_partecipation_roles
    self.group_partecipations.update_all(:partecipation_role_id => 1)
  end
end
