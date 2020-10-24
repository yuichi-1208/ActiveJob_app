require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  # describe "sendmail_blog" do
  #   let(:mail) { NoticeMailer.sendmail_blog }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Sendmail blog")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

  let(:blog){Blog.create(id: 1, title: 'test', content: 'test-content')}
  it 'Jobがエンキューされたか' do
    expect {
      NoticeMailer.sendmail_blog(blog).deliver_later
    }.to have_enqueued_job(ActionMailer::DeliveryJob)
  end
  it '送信されるメールは1通か' do
    expect {
      perform_enqueued_jobs do
        NoticeMailer.sendmail_blog(blog).deliver_later
      end
    }.to change { ActionMailer::Base.deliveries.size }.by(1)
  end
  it 'Job実行後、メールの内容が正しいか' do
    perform_enqueued_jobs do
      NoticeMailer.sendmail_blog(blog).deliver_later
    end
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source
    expect(mail.subject).to eq("【blogapp】blog send")
    expect(mail.to).to eq(["hogehoge@gmail.com"])
    expect(mail.from).to eq(["from@example.com"])
    expect(body).to match(/title: test/)
    expect(body).to match(/content: test-content/)
  end

end
