require 'spec_helper'
require 'rails'

describe SimpleCalendar do
    it 'has a version number' do
        expect(SimpleCalendar::VERSION).not_to be nil
    end
    
    it 'requires simple_calendar' do
        expect(require 'simple_calendar').not_to be nil
    end
    
    it 'requires Rails' do
        expect(require 'rails').not_to be nil
    end
    
end