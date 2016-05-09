describe 'adds slug when creating a profile' do
  let!(:user) { Profile.create!(FactoryGirl.attributes_for(:published, firstname: 'Ada', lastname: 'Lovelace')) }

  describe 'slug' do
    it 'uses the user id' do
      visit "/profiles/#{user.id}"
      expect(page.status_code).to be(200)
    end

    it 'uses the user fullname' do
      visit "/profiles/ada-lovelace"
      expect(page.status_code).to be(200)
    end

    describe 'changing the firstname slug' do
      before do
        user.firstname = "Ama"
        user.save!
      end

      it 'changes the slug' do
        visit "/profiles/ama-lovelace"
        expect(page.status_code).to be(200)
      end
    end
  end

end
