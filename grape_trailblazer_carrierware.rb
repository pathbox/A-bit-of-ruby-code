gem 'grape'        # or web framework you use
gem 'trailblazer'
gem 'carrierwave'

# app/api/v1/endpoints/user.rb
module V1
	module Endpoints
		class Users < Grape::API
			desc 'Upload profile picture for the Current User'

			params do
				requires :picture, type: Rack::Multipart::UploadedFile, desc: 'Profile picture'
			end

			post 'upload_picture' do
				User::UploadPicture.call(params)
				present :url, current_user.profile_picture_url
			end
		end
	end
end

# app/concepts/user/operations/upload_picture.rb 
class User
	class UploadPicture < Trailblazer::Operation
		def process(params)
			uploader = ProfilePictureUploader.new(current_user)
			uploader.store!(params[:picture])
			current_user.update_column(:profile_picture_url, uploader.url)
		end
	end
end

#Good solution for the first case is to change client_max_body_size option of the nginx config to the required file size
#(in case you are using it). But what if we need to upload some another files and their size can be much bigger than allowed
#for pictures? For that use case we can write a form object for the operation where to define some required validations. 
#That's what we will do.

#We can get all the information including actual file size from the picture temp file. Read the docs for the Rack::Multipart::UploadedFile 
#class to find out what else you can get it.

# app/concepts/user/contracts/upload_picture_form.rb 
class User
	class UploadPictureForm < Reform::Form
		property :picture, virtual: true

		MAXIMUM_PICTURE_SIZE = 2.megabytes.freeze

		validate :picture_of_allowed_size?

		private

		def picture_of_allowed_size?
			errors.add(:base, error_message) if picture && picture[:tempfile].size > MAXIMUM_PICTURE_SIZE
		end

		def error_message
			I18n.t('errors.user.invalid_profile_picture_size', size: MAXIMUM_PICTURE_SIZE)
		end
	end
end

rescue_from CarrierWave::UploadError do |e|
	error!({ errors: [e.message] }, 422)
end
















