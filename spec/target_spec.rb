require 'trot/target'


def make_default_config(overrides)
    {
      'name' => 'test',
      'src' => 'foo',
      'default' => true
    }.merge(overrides)
end

def under_test(configoverrides = {}, opts = {})
  @under_test = Trot::Target.new(make_default_config(configoverrides), opts)
end

describe Trot::Target do
  describe '#src' do
    context 'when initialized with a src string' do
      before(:example) do
        under_test
      end
      it 'should include the src string' do
        expect(@under_test.src[:include]).to eq(['foo'])
      end
      it 'should have no excludes' do
        expect(@under_test.src[:exclude]).to be_nil
      end
    end
    context 'when init with an array' do
      before(:example) do
        under_test({
          'src' => ['foo', 'bar']
        })
      end
      it 'should include the src array' do
        expect(@under_test.src[:include]).to eq(['foo', 'bar'])
      end
      it 'should have no excludes' do
        expect(@under_test.src[:exclude]).to be_nil
      end
    end
    context 'when init with excludes' do
      before(:example) do
        under_test('src' => {'include' => ['foo'], 'exclude' => ['foo/bar.c']})
      end
      it 'should include the src array' do
        expect(@under_test.src[:include]).to eq(['foo'])
      end
      it 'should exclude the exclude array' do
        expect(@under_test.src[:exclude]).to eq(['foo/bar.c'])
      end
    end
  end
end