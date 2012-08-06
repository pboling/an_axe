module AnAxe
  class ForumsController < AnAxe::ApplicationController
    layout 'an_axe'
    helper AnAxe::ForumsHelper

    before_filter :login_required, :except => [:index, :show]
    before_filter :find_or_initialize_forum, :except => :index
    prepend_before_filter :admin?, :except => [:show, :index]

    #TODO: put page parameter in URL path so :index & :show can be cached
    #caches_action :index, :show
    #cache_sweeper :posts_sweeper, :only => [ :create, :update, :destroy ]

    def index
      @forums = AnAxe::Forum.an_axe_forums
  #    @forums = Forum.find_ordered
      # reset the page of each forum we have visited when we go back to index
      session[:forum_page] = nil
      respond_to do |format|
        format.html
        format.xml { render :xml => @forums }
      end
    end

    def show
      respond_to do |format|
        format.html do
          # keep track of when we last viewed this forum for activity indicators
          (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?
          (session[:forum_page] ||= Hash.new(1))[@forum.id] = params[:page].to_i if params[:page]

          @topics = @forum.topics.paginate :page => params[:page]
          # TODO: Figure out what this query was for, since it sets no variables passed through to view.
          #Forum.find(:all, :conditions => ['id IN (?)', @topics.collect { |t| t.replied_by }.uniq]) unless @topics.blank?
        end
        format.xml { render :xml => @forum }
      end
    end

    # new renders new.html.erb
    def create
      @forum.attributes = params[:forum]
      #TODO: Generalize
      @forum.account = @account
      unless @forum.save
        render :new and return
      end

      respond_to do |format|
        format.html { redirect_to forum_path(@forum) }
        format.xml  { head :created, :location => forum_url(@forum, :format => :xml) }
      end
    end

    def new
      respond_to do |format|
        format.html
      end
    end

    def edit
      respond_to do |format|
        format.html
      end
    end

    def update
      @forum.update_attributes!(params[:forum])
      respond_to do |format|
        format.html { redirect_to forum_path(@forum) }
        format.xml  { head 200 }
      end
    end

    def destroy
      @forum.destroy
      respond_to do |format|
        format.html { redirect_to forums_path }
        format.xml  { head 200 }
      end
    end

    protected
      def find_or_initialize_forum
        #TODO: Generalize
        @forum = params[:id] ? @account.forums.find(params[:id]) : Forum.new
      end

      alias authorized? admin?
  end
end
