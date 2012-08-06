module AnAxe
  class ApplicationController < ::ApplicationController
    include AnAxe::AuthenticationStub
    helper AnAxe::ApplicationHelper

    unloadable
  end
end
