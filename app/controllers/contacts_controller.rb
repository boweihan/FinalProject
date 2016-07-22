class ContactsController < ApplicationController

  before_action :ensure_logged_in

  def index

    # @messages = []
    # @contacts.each do |contact|
    #   @messages << contact.messages
    # end
    if params[:search]
      @contacts = Contact.all.where(user_id:current_user.id).search(params[:search])
    else
      @contacts = Contact.all.where(user_id:current_user.id)
    end
  end

  def show
    @contact = Contact.find(params[:id])
    @messages = @contact.messages

    # if current_Contact
    #   @review = @contact.reviews.build
    # end
  end

  def new
    @contact = Contact.new
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    if @contact.save
      redirect_to contacts_url
    else
      render :new
    end
  end

  def update
    @contact = Contact.find(params[:id])

    if @contact.update_attributes(contact_params)
      redirect_to contact_url(@contact)
    else
      render :edit
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :phone, :email)
  end
end
