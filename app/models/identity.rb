# -*- encoding : utf-8 -*-

class Identity
  include Mongoid::Document

  embedded_in :user
end