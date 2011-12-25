require 'active_resource'

module Reposman
  class Project < ActiveResource::Base
    self.headers["User-agent"] = "ChiliProject repository manager/#{Version}"
  end
end