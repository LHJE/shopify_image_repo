require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Images Index', type: :view do
  describe 'As any user' do
    before :each do
      @user_1 = User.create(name: 'Morgan', email: 'morgan@example.com', password: 'securepassword', password_confirmation: 'securepassword')
      @user_2 = User.create(name: 'Jackie Chan', email: 'its@jackie.com', password: 'securepassword', password_confirmation: 'securepassword')
      @image_1 = assign(:image, Image.create!(
        title: "MyString1",
        body: "MyText1",
        keyword: "MyString1",
        user_id: @user_1.id
      ))
      @image_2 = assign(:image, Image.create!(
        title: "MyString2",
        body: "MyText2",
        keyword: "MyString2",
        user_id: @user_1.id
      ))
      @image_3 = assign(:image, Image.create!(
        title: "MyString3",
        body: "MyText3",
        keyword: "MyString3",
        user_id: @user_2.id
      ))
      @image_4 = assign(:image, Image.create!(
        title: "MyString4",
        body: "MyText4",
        keyword: "MyString4",
        user_id: @user_2.id
      ))
    end

    describe 'as a visitor', type: :feature do
      it 'can see base headers' do
        visit '/images'

        expect(page).to have_content("The Image Repo!")
        expect(page).to have_content("The Images, most recent at the top:")
        expect(page).to_not have_link("Upload An Image")
        expect(page).to have_content("Please Log In or Register if you'd like to Upload an Image!")
        within '.login' do
          expect(page).to have_link("Log In")
          expect(page).to have_link("Register")
        end
      end

      it "can see images that have been uploaded" do
        visit '/images'

        within "#image-#{@image_1.id}" do
          expect(page).to have_content(@image_1.title)
        end
        within "#image-#{@image_2.id}" do
          expect(page).to have_content(@image_2.title)
        end
        within "#image-#{@image_3.id}" do
          expect(page).to have_content(@image_3.title)
        end
        within "#image-#{@image_4.id}" do
          expect(page).to have_content(@image_4.title)
        end
      end
    end

    describe 'As a user', type: :feature do
      before :each do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
        visit '/images'
      end

      it 'can see base headers' do
        expect(page).to have_content("The Image Repo!")
        expect(page).to have_content("The Images, most recent at the top:")
        expect(page).to have_link("Upload An Image")
      end

      it "can see images that have been uploaded" do
        within "#image-#{@image_1.id}" do
          expect(page).to have_content(@image_1.title)
        end
        within "#image-#{@image_2.id}" do
          expect(page).to have_content(@image_2.title)
        end
        within "#image-#{@image_3.id}" do
          expect(page).to have_content(@image_3.title)
        end
        within "#image-#{@image_4.id}" do
          expect(page).to have_content(@image_4.title)
        end
      end

      it "can go to update page when Edit clicked" do
        within "#image-#{@image_1.id}" do
          click_link 'Edit'
        end

        expect(current_path).to eq("/images/#{@image_1.id}/edit")
      end

      it "can go to update page when Edit clicked" do
        within "#image-#{@image_1.id}" do
          click_link 'Destroy'
        end

        expect(current_path).to eq("/images")
        expect(page).to_not have_content(@image_1.title)
      end
    end
  end
end
