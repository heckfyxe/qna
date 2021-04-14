shared_examples_for 'votable model' do
  describe '#vote_up' do
    it 'User votes' do
      expect { model.vote_up(user) }.to change(Vote, :count).by(1)
      expect(Vote.last.value).to eq 1
    end
  end

  describe '#vote_down' do
    it 'User votes' do
      expect { model.vote_down(user) }.to change(Vote, :count).by(1)
      expect(Vote.last.value).to eq -1
    end
  end

  describe '#rating' do
    it 'show total votes' do
      model.vote_up(user)
      model.reload

      expect(model.rating).to eq 1

      model.vote_down(another_user)
      model.reload

      expect(model.rating).to eq 0

      model.vote_down(user)
      model.reload

      expect(model.rating).to eq -1
    end
  end

  describe '#user_vote' do
    it "show user's vote" do
      model.vote_up(user)
      model.vote_up(another_user)
      model.reload
      expect(model.user_vote(user)).to eq 1
    end
  end
end