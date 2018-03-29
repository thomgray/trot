require 'trot/builder'
require 'trot/target'
require_relative 'mocks/mock_fs'

def make_test_target(overrides = {}, opts = {default: true})
  config = {
    'name' => 'test',
    'dest' => '/foo/dest',
    'src' => {
      'include' => ['/foo/bar/src']
    }
  }.merge(overrides)
  Trot::Target.new(config, opts)
end

describe Trot::Builder do
  before(:each) do
    $trot_build_dir = '/foo/.trotBuild'
    $fs = Trot::MockFS.new
    $config = double('config')
    $compiler = double('compiler')

    allow($compiler).to receive(:compile)
    allow($compiler).to receive(:link)
    allow($compiler).to receive(:link_static_lib)
  end

  describe '#build' do
    context 'with default proto' do
      before(:example) do
        @under_test = Trot::Builder.new(make_test_target)
      end

      context 'when targets should be updated' do
        before(:example) do
          allow(Trot::Make).to receive(:should_update_target).and_return(true)
          @under_test.build
        end

        it 'compiles the object files' do
          expect($compiler).to have_received(:compile).with(
            ['/foo/bar/main.c', '/foo/bar/foo.c'],
            '/foo/.trotBuild/objectFiles'
          )
        end

        it "links the object files" do
          expect($compiler).to have_received(:link).with(
            ['/foo/.trotBuild/objectFiles/main.o', '/foo/.trotBuild/objectFiles/foo.o'],
            '/foo/dest'
          )
        end
      end
      
      context 'when targets should not be updated' do
        before(:example) do
          allow(Trot::Make).to receive(:should_update_target).and_return(false)
          @under_test.build
        end
        it 'compiles the object files' do
          expect($compiler).not_to have_received(:compile)
        end

        it "links the object files" do
          expect($compiler).not_to have_received(:link)
        end
      end
    end
    
    context 'with staticLib target' do
      before(:example) do
        allow(Trot::Make).to receive(:should_update_target).and_return(true)
        target = make_test_target('staticLib' => true)
        @under_test = Trot::Builder.new(target)
        @under_test.build
      end

      it 'compiles object files' do
        expect($compiler).to have_received(:compile).with(
          ['/foo/bar/main.c', '/foo/bar/foo.c'],
          '/foo/.trotBuild/objectFiles'
        )
      end
      
      it 'links static library' do
        expect($compiler).to have_received(:link_static_lib).with(
          ['/foo/.trotBuild/objectFiles/main.o', '/foo/.trotBuild/objectFiles/foo.o'],
          '/foo/dest.a'
        )
      end
    end
    
    context 'with ignored files' do
      before(:example) do
        target = make_test_target(
          'src' => {
            'include' => ['/foo/bar'],
            'exclude' => ['/foo/bar/main.c']
          }
        )
        allow($fs).to receive(:files_recursive).and_return(
          ['/foo/bar/foo.c', '/foo/bar/main.c'], # first call for includes
          ['/foo/bar/main.c']                    # second call for excludes
        )
        @under_test = Trot::Builder.new(target)
        @under_test.build
      end

      it 'checks for included files' do
        expect($fs).to have_received(:files_recursive).with('/foo/bar')
      end
      
      it 'checks for excluded files' do
        expect($fs).to have_received(:files_recursive).with('/foo/bar/main.c')
      end

      it 'doesn\'t compile ignored files' do
        expect($compiler).to have_received(:compile).with(
          ['/foo/bar/foo.c'], '/foo/.trotBuild/objectFiles'
        )
      end

      it 'doesn\'t link ignored files' do
        expect($compiler).to have_received(:link).with(
          ['/foo/.trotBuild/objectFiles/foo.o'], '/foo/dest'
        )
      end
    end
  end

  describe '#link_object_files' do
    it 'should ' do
      
    end
  end
end