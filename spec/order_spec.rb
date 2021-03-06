# encoding: utf-8
require 'spec_helper'
require 'timecop'

module Clearsale
  describe Order do
    before :each do
      Timecop.freeze Time.parse('2012-07-01 11:13')
    end

    let(:_order) { Object.new(order) }
    let(:_payment) { Object.new(payment) }
    let(:_user) { Object.new(user) }

    describe ".to_xml" do
      it "converts the order to xml successfully" do
        described_class.to_xml(_order, _payment, _user).should eq '<ClearSale><Orders><Order><ID>1234</ID><Date>2012-07-01T11:13:00</Date><Email>petergriffin@abc.com</Email><TotalItens>20.0</TotalItens><TotalOrder>25.0</TotalOrder><QtyInstallments>3</QtyInstallments><QtyItems>3</QtyItems><IP>127.0.0.1</IP><CollectionData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>1972-07-01T11:13:00</BirthDate><Email>petergriffin@abc.com</Email><Genre>m</Genre><Address><Street>Billing Street</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></CollectionData><ShippingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>1972-07-01T11:13:00</BirthDate><Email>petergriffin@abc.com</Email><Genre>m</Genre><Address><Street>Shipping Street</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></ShippingData><Payments><Payment><Date>2012-07-01T11:12:58</Date><Amount>50.0</Amount><PaymentTypeID>1</PaymentTypeID><QtyInstallments>3</QtyInstallments><CardNumber>1234432111112222</CardNumber><CardBin>123443</CardBin><CardType>3</CardType><CardExpirationDate>05/2012</CardExpirationDate><Name/><LegalDocument>24878346337</LegalDocument><Address><Street>Billing Street</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address></Payment></Payments><Items><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item></Items></Order></Orders></ClearSale>'
      end

      context "about credit card acquirer" do
        it "should accept symbol" do
          _payment.acquirer = :amex
          described_class.to_xml(_order, _payment, _user).should include "<CardType>#{Clearsale::Order::CARD_TYPE_MAP[:amex]}</CardType>"
        end

        it "should accept string" do
          _payment.acquirer = 'amex'
          described_class.to_xml(_order, _payment, _user).should include "<CardType>#{Clearsale::Order::CARD_TYPE_MAP[:amex]}</CardType>"
        end
      end

      context "when birthdate is empty" do
        it "should not send birthdate" do
          _user.birthdate = nil
          described_class.to_xml(_order, _payment, _user).should_not include "<BirthDate>"
        end

        it "should not send birthdate" do
          _user.birthdate = nil
          expect{ described_class.to_xml(_order, _payment, _user) }.to_not raise_error
        end
      end
    end
  end
end
