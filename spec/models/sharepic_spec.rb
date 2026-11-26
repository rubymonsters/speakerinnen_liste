require 'rails_helper'

RSpec.describe Sharepic, type: :model do
  it 'has a valid factory' do
    expect(build(:sharepic)).to be_valid
  end

  it 'requires a title' do
    expect(build(:sharepic, title: '')).not_to be_valid
  end

  it 'requires an image' do
    sharepic = Sharepic.new(title: 'Ohne Bild')
    expect(sharepic).not_to be_valid
    expect(sharepic.errors[:image]).to be_present
  end

  it 'rejects non-image files' do
    sharepic = build(:sharepic)
    sharepic.image.attach(io: StringIO.new('hello'), filename: 'a.txt', content_type: 'text/plain')
    expect(sharepic).not_to be_valid
    expect(sharepic.errors[:image]).to include(I18n.t('activerecord.errors.models.sharepic.attributes.image.invalid_content_type'))
  end

  it 'rejects files that are too big' do
    sharepic = build(:sharepic)
    allow(sharepic.image.blob).to receive(:byte_size).and_return(Sharepic::MAX_FILE_SIZE + 1)
    expect(sharepic).not_to be_valid
  end

  describe '.published' do
    it 'only returns published sharepics' do
      shown = create(:sharepic)
      create(:sharepic, published: false)
      expect(Sharepic.published).to contain_exactly(shown)
    end
  end
end
