require 'spec_helper'

RSpec.describe 'Attach file' do
  let(:file) do
    filename = 'generic_avatar.jpeg'
    {
      io: File.open(
        File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))
      ),
      filename: filename
    }
  end

  let!(:rails_url) { Rails.application.routes.url_helpers }
  let(:user)       { User.create }

  context 'when user uses an avatar' do
    context 'when user does not have an avatar attached yet' do
      it 'does not have an avatar attached' do
        expect(user.avatar.attached?).not_to be
      end

      context 'when "user.avatar.attach" is called' do
        it 'attaches an avatar to the user' do
          user.avatar.attach(file)

          expect(user.avatar.attached?).to be
        end
      end

      context 'when "user.avatar=" is called' do
        it 'attaches an avatar to the user' do
          user.avatar = file

          expect(user.avatar.attached?).to be
        end
      end

      context 'when the avatar is sent as a hash parameter to the user' do
        it 'attaches an avatar to the user' do
          user = User.create(avatar: file)

          expect(user.avatar.attached?).to be
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
      let(:user) { User.create(avatar: file) }

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
    let(:second_file) do
      filename = 'generic-logo.png'

      {
        io: File.open(
          File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))
        ),
        filename: filename
      }
    end
    let(:pictures_attachments) { [file, second_file] }

    context 'when user does not have any pictures attached yet' do
      it 'does not have any pictures attached' do
        expect(user.pictures.attached?).not_to be
      end

      context 'when "user.pictures.attach" is called' do
        context 'when it is called with only one picture' do
          it 'attaches a picture to the user' do
            user.pictures.attach(file)

            expect(user.pictures.attached?).to be
          end
        end

        context 'when it is called with more than one picture' do
          it 'attaches an array of pictures to the user' do
            user.pictures.attach(pictures_attachments)

            expect(user.pictures.count).to eq(2)
          end

          it 'attaches multiple individual pictures to the user' do
            user.pictures.attach(file)
            user.pictures.attach(second_file)

            expect(user.pictures.count).to eq(2)
          end
        end
      end

      context 'when "user.pictures=" is called' do
        context 'when it is called with only one picture' do
          it 'attaches a picture to the user' do
            user.pictures = file

            expect(user.pictures.attached?).to be
          end
        end

        context 'when it is called with more than one picture' do
          it 'attaches an array of pictures to the user' do
            user.pictures = pictures_attachments

            expect(user.pictures.count).to eq(2)
          end

          it 'attaches multiple individual pictures to the user' do
            user.pictures = file
            user.pictures = second_file

            expect(user.pictures.count).to eq(2)
          end
        end
      end

      context 'when pictures are passed as a hash parameter' do
        context 'when a single picture is passed' do
          it 'attaches a picture' do
            user = User.create(pictures: file)

            expect(user.pictures.attached?).to be
          end
        end

        context 'when an array of pictures is passed' do
          it 'attaches multiple pictures' do
            user = User.create(pictures: pictures_attachments)

            expect(user.pictures.count).to eq(2)
          end
        end
      end

      context 'when user already has pictures attached' do
        context 'when user has only one picture attached' do
          let(:user) { User.create(pictures: file) }

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
