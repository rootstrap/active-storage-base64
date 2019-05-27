require 'spec_helper'

RSpec.describe 'Attach base64' do
  let(:filename) { 'generic_avatar.jpeg' }
  let(:file) do
    File.open(File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))).read
  end

  let(:second_filename) { 'generic-logo.png' }
  let(:second_file) do
    File.open(File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', second_filename))).read
  end

  let(:base64_data)        { { data: "data:image/jpeg;base64,#{Base64.encode64(file)}" } }
  let(:second_base64_data) { { data: "data:image/png;base64,#{Base64.encode64(second_file)}" } }

  let(:data_with_filename)        { base64_data.merge(filename: filename) }
  let(:second_data_with_filename) { second_base64_data.merge(filename: second_filename) }

  let!(:rails_url) { Rails.application.routes.url_helpers }
  let(:user)       { User.create }

  context 'when user uses an avatar' do
    context 'when user does not have an avatar attached yet' do
      it 'does not have an avatar attached' do
        expect(user.avatar.attached?).not_to be
      end

      context 'when "user.avatar.attach" is called' do
        context 'when only data is specified' do
          it 'attaches an avatar to the user' do
            user.avatar.attach(base64_data)

            expect(user.avatar.attached?).to be
          end

          it 'attached file matches attachment file' do
            user.avatar.attach(base64_data)

            expect(
              File.open(ActiveStorage::Blob.service.send(:path_for, user.avatar.key)).read
            ).to match(file)
          end
        end

        context 'when filename is specified along with data' do
          it 'assigns the specified filename' do
            user.avatar.attach(data_with_filename)

            expect(user.avatar.filename.to_s).to eq(filename)
          end
        end
      end

      context 'when "user.avatar=" is called' do
        context 'when only data is specified' do
          it 'attaches an avatar to the user' do
            user.avatar = base64_data
            user.save

            expect(user.avatar.attached?).to be
          end

          it 'attached file matches attachment file' do
            user.avatar = base64_data
            user.save

            expect(
              File.open(ActiveStorage::Blob.service.send(:path_for, user.avatar.key)).read
            ).to match(file)
          end
        end

        context 'when filename is specified along with data' do
          it 'assigns the specified filename' do
            user.avatar = data_with_filename
            user.save

            expect(user.avatar.filename.to_s).to eq(filename)
          end
        end
      end

      context 'when the avatar is sent as a hash parameter to the user' do
        context 'when only data is specified' do
          it 'attaches an avatar to the user' do
            user = User.create(avatar: base64_data)

            expect(user.avatar.attached?).to be
          end

          it 'attached file matches attachment file' do
            user = User.create(avatar: base64_data)

            expect(
              File.open(ActiveStorage::Blob.service.send(:path_for, user.avatar.key)).read
            ).to match(file)
          end
        end

        context 'when filename is specified along with data' do
          it 'assigns the specified filename' do
            user = User.create(avatar: data_with_filename)

            expect(user.avatar.filename).to eq(filename)
          end
        end
      end

      context 'when a link to the avatar file is required' do
        it 'raises a Module::DelegationError error' do
          expect do
            rails_url.rails_blob_url(user.avatar, disposition: 'attachment')
          end.to raise_error(Module::DelegationError)
        end
      end
    end

    context 'when user has an avatar attached' do
      let(:user) { User.create(avatar: base64_data) }

      context 'when the user wants to remove the avatar' do
        it 'removes the avatar' do
          user.avatar.purge

          expect(user.avatar.attached?).not_to be
        end
      end

      context 'when a link to the avatar file is required' do
        it 'returns a link' do
          url = rails_url.rails_blob_url(user.avatar, disposition: 'attachment')

          expect(url).to be
        end
      end
    end
  end

  context 'when user uses pictures' do
    let(:pictures_attachments) { [base64_data, second_base64_data] }
    let(:attachments_with_filename) { [data_with_filename, second_data_with_filename] }

    context 'when user does not have any pictures attached yet' do
      it 'does not have any pictures attached' do
        expect(user.pictures.attached?).not_to be
      end

      context 'when "user.pictures.attach" is called' do
        context 'when it is called with only one picture' do
          context 'when only data is specified' do
            it 'attaches a picture to the user' do
              user.pictures.attach(base64_data)

              expect(user.pictures.attached?).to be
            end

            it 'attached file matches attachment file' do
              user.pictures.attach(base64_data)

              expect(
                File.open(ActiveStorage::Blob.service.send(:path_for, user.pictures.first.key)).read
              ).to match(file)
            end
          end

          context 'when a filename is specified along with data' do
            it 'assigns the specified filename' do
              user.pictures.attach(data_with_filename)

              expect(user.pictures.first.filename.to_s). to eq(filename)
            end
          end
        end

        context 'when it is called with more than one picture' do
          context 'when only data is specified' do
            it 'attaches an array of pictures to the user' do
              user.pictures.attach(pictures_attachments)

              expect(user.pictures.count).to eq(2)
            end

            it 'attached file matches attachment file' do
              user.pictures.attach(pictures_attachments)

              expect(
                File.open(ActiveStorage::Blob.service.send(:path_for, user.pictures.last.key)).read
              ).to match(second_file)
            end

            it 'attaches multiple individual pictures to the user' do
              user.pictures.attach(base64_data)
              user.pictures.attach(second_base64_data)

              expect(user.pictures.count).to eq(2)
            end
          end

          context 'when pictures have a specific filename' do
            it 'assigns the specified filename for the array of pictures' do
              user.pictures.attach(attachments_with_filename)

              expect(user.pictures.first.filename.to_s).to eq(filename)
              expect(user.pictures.second.filename.to_s).to eq(second_filename)
            end

            it 'assigns the specifiied filename for each individual picture' do
              user.pictures.attach(data_with_filename)
              user.pictures.attach(second_data_with_filename)

              expect(user.pictures.first.filename.to_s).to eq(filename)
              expect(user.pictures.second.filename.to_s).to eq(second_filename)
            end
          end
        end
      end

      context 'when "user.pictures=" is called' do
        context 'when it is called with only one picture' do
          context 'when only data is specified' do
            it 'attaches a picture to the user' do
              user.pictures = base64_data
              user.save

              expect(user.pictures.attached?).to be
            end

            it 'attached file matches attachment file' do
              user.pictures = base64_data
              user.save

              expect(
                File.open(ActiveStorage::Blob.service.send(:path_for, user.pictures.last.key)).read
              ).to match(file)
            end
          end

          context 'when filename is specified' do
            it 'assigns the specified filename' do
              user.pictures = data_with_filename
              user.save

              expect(user.pictures.first.filename.to_s).to eq(filename)
            end
          end
        end

        context 'when it is called with more than one picture' do
          context 'when only data is specified' do
            it 'attaches an array of pictures to the user' do
              user.pictures = pictures_attachments
              user.save

              expect(user.pictures.count).to eq(2)
            end

            it 'attached file matches attachment file' do
              user.pictures = pictures_attachments
              user.save

              expect(
                File.open(ActiveStorage::Blob.service.send(:path_for, user.pictures.last.key)).read
              ).to match(second_file)
            end

            it 'attaches multiple individual pictures to the user' do
              user.pictures = [base64_data, second_base64_data]
              user.save

              expect(user.pictures.count).to eq(2)
            end
          end

          context 'when pictures have a specified filename' do
            it 'assigns the specified filename for the array of pictures' do
              user.pictures = attachments_with_filename
              user.save

              expect(user.pictures.first.filename.to_s).to eq(filename)
              expect(user.pictures.second.filename.to_s).to eq(second_filename)
            end

            it 'assigns the specified filename for each individual picture' do
              user.pictures = [data_with_filename, second_data_with_filename]
              user.save

              expect(user.pictures.first.filename.to_s).to eq(filename)
              expect(user.pictures.second.filename.to_s).to eq(second_filename)
            end
          end
        end
      end

      context 'when pictures are passed as a hash parameter' do
        context 'when a single picture is passed' do
          context 'when only data is specified' do
            it 'attaches a picture' do
              user = User.create(pictures: base64_data)

              expect(user.pictures.attached?).to be
            end

            it 'attached file matches attachment file' do
              user = User.create(pictures: base64_data)

              expect(
                File.open(ActiveStorage::Blob.service.send(:path_for, user.pictures.last.key)).read
              ).to match(file)
            end
          end

          context 'when a filename is specified' do
            it 'assigns the specified filename' do
              user = User.create(pictures: data_with_filename)

              expect(user.pictures.first.filename.to_s).to eq(filename)
            end
          end
        end

        context 'when an array of pictures is passed' do
          it 'attaches multiple pictures' do
            user = User.create(pictures: attachments_with_filename)

            expect(user.pictures.first.filename.to_s).to eq(filename)
            expect(user.pictures.second.filename.to_s).to eq(second_filename)
          end
        end
      end

      context 'when user already has pictures attached' do
        context 'when user has only one picture attached' do
          let(:user) { User.create(pictures: base64_data) }

          context 'when the user wants to remove the picture' do
            it 'removes the picture' do
              user.pictures.purge

              expect(user.pictures.attached?).not_to be
            end
          end
        end

        context 'when user has multiple pictures attached' do
          let(:user) { User.create(pictures: pictures_attachments) }

          context 'when user wants to remove the pictures' do
            it 'removes the pictures' do
              user.pictures.purge

              expect(user.pictures.attached?).not_to be
            end
          end

          context 'when a url for a picture is required' do
            it 'returns a url for the picture' do
              url = rails_url.rails_blob_url(user.pictures.first, disposition: 'attachment')

              expect(url).to be
            end

            it 'url for pictures is different' do
              first_url = rails_url.rails_blob_url(user.pictures.first, disposition: 'attachment')
              second_url = rails_url.rails_blob_url(user.pictures.second, disposition: 'attachment')

              expect(first_url).not_to eq(second_url)
            end
          end
        end
      end
    end
  end
end
