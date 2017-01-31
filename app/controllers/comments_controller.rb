class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # def show
  # end

  # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    if params[:project_id].present?
      commentable = Project.find(params[:project_id])
    elsif params[:article_id].present?
      commentable = Article.find(params[:article_id])
    end

    @comment = commentable.comments.build(comment_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to polymorphic_path(commentable, anchor: "floor-#{@comment.floor}"), notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to :back, alert: "#{@comment.errors.full_messages.join(';')}" }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    authorize! :update, @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to polymorphic_path(@commentable, anchor: "floor-#{@comment.floor}"), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    authorize! :destroy, @comment

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to polymorphic_url(@commentable), notice: 'Comment was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])

      @commentable = @comment.commentable
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :commentable_id,
        :commentable_type)
    end
end
