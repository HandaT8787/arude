RSpec.shared_context "グループ投稿のデータ" do
  let(:group) { create(:group) }
  let(:member) { create(:user) }
  let(:outsider) { create(:user) }
  let(:author) { create(:user) }

  before do
    create(:group_membership, user: member, group: group)
    create(:group_membership, user: author, group: group)
  end

  let!(:public_post) { create(:post, title: "public_post", user: author) }
  let!(:group_post) { create(:post, title: "group_only", description: "secret_keyword", group: group, user: author) }
  
end