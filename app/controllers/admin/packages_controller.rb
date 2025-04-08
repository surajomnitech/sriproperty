module Admin
  class PackagesController < BaseController
    before_action :set_package, only: [:edit, :update, :destroy]

    def index
      @packages = Package.all
    end

    def new
      @package = Package.new
    end

    def create
      @package = Package.new(package_params)

      if @package.save
        redirect_to admin_packages_path, notice: 'Package was successfully created.'
      else
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
      if @package.destroy
        redirect_to admin_packages_path, notice: 'Package was successfully deleted.'
      else
        redirect_to admin_packages_path, alert: @package.errors.full_messages.to_sentence
      end
    end

    private

    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params.require(:package).permit(
        :name,
        :free_listings_count,
        :max_photos_per_listing,
        :is_default,
        :status
      )
    end
  end
end