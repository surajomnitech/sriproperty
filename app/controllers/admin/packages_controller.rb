module Admin
  class PackagesController < BaseController
    before_action :set_package, only: [:show, :edit, :update, :destroy]

    def index
      @packages = Package.ordered_by_price
    end

    def show
      @user_purchases = @package.user_package_purchases.includes(:user).recent_first.limit(10)
    end

    def new
      @package = Package.new
    end

    def create
      @package = Package.new(package_params)

      if @package.save
        redirect_to admin_packages_path, notice: 'Package was successfully created.'
      else
        flash.now[:alert] = @package.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @package.update(package_params)
        redirect_to admin_packages_path, notice: 'Package was successfully updated.'
      else
        flash.now[:alert] = @package.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @package.is_default?
        redirect_to admin_packages_path, alert: 'Cannot delete the default package.'
      elsif @package.user_package_purchases.exists?
        redirect_to admin_packages_path, alert: 'Cannot delete package with active purchases.'
      else
        @package.destroy
        redirect_to admin_packages_path, notice: 'Package was successfully deleted.'
      end
    end

    private

    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params.require(:package).permit(
        :name, 
        :description,
        :duration_days,
        :free_listings_per_cycle,
        :max_paid_listings,
        :listing_duration_days,
        :price,
        :invoice_required,
        :is_default,
        :status
      )
    end
  end
end