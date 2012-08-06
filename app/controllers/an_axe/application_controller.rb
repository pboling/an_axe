module AnAxe
  class ApplicationController < ::ApplicationController
    include AnAxe::AuthenticationStub
    helper ApplicationHelper

    unloadable
  end
end
