class Admin::UserPackagePurchasesController < Admin::BaseController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  
  before_action :set_purchase, only: [:show, :edit, :update, :approve_payment, :cancel_purchase, :remove_document]
  before_action :load_form_data, only: [:new, :edit]

  def index
    @purchases = UserPackagePurchase.includes(:user, :package).order(created_at: :desc).page(params[:page])
  end

  def show
    @listing_cycles = @purchase.listing_cycles.order(cycle_start_date: :asc)
  end

  def new
    @purchase = UserPackagePurchase.new
  end

  def edit; end

  def create
    @purchase = UserPackagePurchase.new(purchase_params)

    if @purchase.save
      redirect_to admin_user_package_purchases_path, notice: 'Purchase created successfully.'
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @purchase.update(purchase_params.except(:payment_documents))
      # Handle file attachments separately
      if params[:user_package_purchase][:payment_documents].present?
        @purchase.payment_documents.attach(params[:user_package_purchase][:payment_documents])
        
        respond_to do |format|
          format.html { redirect_to admin_user_package_purchases_path, notice: 'Purchase updated successfully.' }
          format.turbo_stream { 
            load_form_data
            render turbo_stream: [
              turbo_stream.update('document-list', 
                render_to_string(partial: 'document_list', locals: { purchase: @purchase })
              ),
              turbo_stream.update('file-upload-reset', '<span data-file-upload-target="reset"></span>')
            ]
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_user_package_purchases_path, notice: 'Purchase updated successfully.' }
          format.turbo_stream { head :ok }
        end
      end
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end

  def approve_payment
    if @purchase.pending?
      @purchase.update(payment_status: :paid, payment_date: Time.current)
      redirect_to admin_user_package_purchases_path, notice: 'Payment approved successfully.'
    else
      redirect_to admin_user_package_purchases_path, alert: 'Purchase is not in pending state.'
    end
  end

  def cancel_purchase
    if @purchase.can_be_cancelled?
      @purchase.update(payment_status: :cancelled)
      redirect_to admin_user_package_purchases_path, notice: 'Purchase cancelled successfully.'
    else
      redirect_to admin_user_package_purchases_path, alert: 'Purchase cannot be cancelled.'
    end
  end

  def remove_document
    begin
      blob = ActiveStorage::Blob.find_signed!(params[:document_id])
      attachment = blob.attachments.first
      attachment.purge

      respond_to do |format|
        format.html { redirect_to edit_admin_user_package_purchase_path(@purchase), notice: 'Document removed.' }
        format.turbo_stream { 
          load_form_data
          render turbo_stream: turbo_stream.update('document-list', 
            render_to_string(partial: 'document_list', locals: { purchase: @purchase })
          )
        }
      end
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to edit_admin_user_package_purchase_path(@purchase), alert: 'Invalid document.'
    end
  end

  private

  def set_purchase
    @purchase = UserPackagePurchase.find(params[:id])
  end

  def load_form_data
    @users = User.all
    @packages = Package.all
  end

  def purchase_params
    params.require(:user_package_purchase).permit(
      :user_id, :package_id, :units, :start_date, :payment_status,
      :invoice_number, :payment_reference, :payment_date, :admin_notes,
      payment_documents: []
    )
  end
end