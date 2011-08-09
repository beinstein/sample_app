class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  email_regex = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  validates :name,    :presence => true,
                      :length => { :maximum => 50}
  
  validates :email,   :presence => true,
                      :format => { :with => email_regex },
                      :uniqueness => { :case_sensitive => false}
  
end
