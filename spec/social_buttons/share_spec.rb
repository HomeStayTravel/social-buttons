require 'view_helper_config'

describe SocialButtons::ViewHelper do
  include ControllerTestHelpers,
          SocialButtons::ViewHelper

  describe '#share_button' do
    context 'no arguments' do
      it "should require a Facebook app id" do
        expect { share_button }.to raise_error
      end
    end

    context 'with app_id' do
      it "should require a Facebook app id" do
        expect { share_button('128085897213395') }.to_not raise_error
      end
    end

    context 'with options' do
      it "should set width using option" do
        output = share_button('128085897213395', layout: 'icon_link')
        output.should match(/data-layout="icon_link"/)
        output.should match(/<script/)

        output = share_button('128085897213395', layout: 'icon_link')
        output.should_not match(/<script/)
      end
    end

    context 'with script - on next request' do
      it "should render script again on next request!" do
        output = share_button('128085897213395', layout: 'icon_link')
        output.should match(/data-layout="icon_link"/)
        output.should match(/<script/)
      end

      it "should not render script twice if like and share buttons are displayed!" do
        output = share_button('128085897213395', layout: 'icon_link')
        output.should match(/data-layout="icon_link"/)
        output.should match(/<script/)

        output = like_button('128085897213395')
        output.should_not match(/<script/)
      end
    end
  end
end
