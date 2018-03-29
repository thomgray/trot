require 'trot/builder'
require_relative 'mocks/mock_fs'

def make_test_target(overrides = {})
  {
    name: 'test',
    dest: '/foo/dest',
    sourceDir: '/foo/bar/src',
    target: '/foo/bar/build/testTarget'
  }.merge(overrides)
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
            '/foo/.trotBuild/test/objectFiles'
          )
        end

        it "links the object files" do
          expect($compiler).to have_received(:link).with(
            ['/foo/.trotBuild/test/objectFiles/main.o', '/foo/.trotBuild/test/objectFiles/foo.o'],
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
    
    context 'with staticLib proto' do
      before(:example) do
        allow(Trot::Make).to receive(:should_update_target).and_return(true)
        conf = make_test_target(staticLib: true)
        @under_test = Trot::Builder.new(make_test_target(conf))
        @under_test.build
      end

      it 'compiles object files' do
        expect($compiler).to have_received(:compile).with(
          ['/foo/bar/main.c', '/foo/bar/foo.c'],
          '/foo/.trotBuild/test/objectFiles'
        )
      end
      
      it 'links static library' do
        expect($compiler).to have_received(:link_static_lib).with(
          ['/foo/.trotBuild/test/objectFiles/main.o', '/foo/.trotBuild/test/objectFiles/foo.o'],
          '/foo/dest.a'
        )
      end
    end
    
    context 'with ignored files' do
      it 'doesn\t compile or link ignored files' do
        @under_test = Trot::Builder.new(make_test_target(ignore: '/foo/bar/src/foo.c'))
        @under_test.build
        
        expect($compiler).to have_received(:compile).with(
          ['/foo/bar/foo.c'], '/foo/.trotBuild/objectFiles'
        )
      end
    end
  end
    
  describe '#link_object_files' do
    it 'should ' do
      
    end
  end
  
end