shared_examples_for 'files field' do
  it 'return list of files urls' do
    expect(files_response.size).to eq files.size
    files_response.each do |url|
      expect(url).to be_a String
    end
  end
end
