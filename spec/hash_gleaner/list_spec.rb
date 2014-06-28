# -*- encoding: utf-8 -*-
require 'spec_helper'

describe HashGleaner::List do
  let(:missing_keys) { HashGleaner::MissingKeys.new }

  describe '#o' do
    context 'when an original Hash has the specified key' do
      let(:original_hash) do
        {
          foo: :zzz,
          baa: [:wibble, :wobble, :wubble],
          baz: {
            spam: :pee,
            ham: :kaa,
            egg: :boo,
          },
          qux: [
            {
              toto: :hoge,
              titi: :fuga,
              tutu: :piyo,
            },
            {
              toto: :bla,
              titi: :bla,
              tutu: :bla,
            },
          ],
          xyzzy: [
            [:a, :b, :c],
            {
              spam: :_,
              ham:  :_,
              egg:  :_,
            },
            {
              hoge: {
                foo: [:wibble],
              },
              fuge: {
                foo: :a,
              },
              piyo: [
                {
                  abc: :x,
                  def: :y,
                  ghi: :z,
                },
              ],
            },
          ],
        }
      end

      let(:gleaner) do
        described_class.new(original_hash, missing_keys)
      end

      context 'and the value is not a Hash nor an Array' do
        subject { gleaner.o :foo }

        it "returns a Hash that contains the key and the value" do
          expect(subject).to have_key(:foo)
          expect(subject[:foo]).to be :zzz
        end
      end

      context 'and the value is a Hash' do
        context 'and passed no block' do
          subject { gleaner.o :baz }

          it "returns a Hash that contains the key and " \
             "a blank Hash as its value" do
            expect(subject).to have_key(:baz)

            value = subject[:baz]
            expect(value).to be_an_instance_of(Hash)
            expect(value).to be_empty
          end
        end

        context 'and passed a block' do
          subject {
            gleaner.o :baz do
              o :ham
              o :egg
            end
          }

          it "returns a Hash that contains the key and " \
             "a hash that has pairs the block defined" do
            expect(subject).to have_key(:baz)

            value = subject[:baz]
            expect(value).to be_an_instance_of(Hash)
            expect(value.keys).to match_array([:ham, :egg])
            expect(value[:ham]).to be :kaa
            expect(value[:egg]).to be :boo
          end
        end
      end

      context 'and the value is an Array of scalas' do
        subject { gleaner.o :baa }

        it "returns a Hash that contains the key and the array" do
          expect(subject).to have_key(:baa)

          value = subject[:baa]
          expect(value).to be_an_instance_of(Array)
          expect(value.size).to be 3
          expect(value[0]).to be :wibble
          expect(value[1]).to be :wobble
          expect(value[2]).to be :wubble
        end
      end

      context 'and the value is an Array of Hashs' do
        context 'and no block is passed' do
          subject { gleaner.o :qux }

          it "returns a Hash that contains the key and a blank Array as its value" do
            expect(subject).to have_key(:qux)

            value = subject[:qux]
            expect(value).to be_an_instance_of(Array)
            expect(value).to be_empty
          end
        end

        context 'and a block is passed' do
          subject {
            gleaner.o :qux do
              o :toto
              o :tutu
            end
          }

          it "returns a Hash that contains the key and an Array of Hashs " \
             "that has the pairs of a key and a value that is defined the block" do
            expect(subject).to have_key(:qux)

            value = subject[:qux]
            expect(value).to be_an_instance_of(Array)
            expect(value[0]).to be_an_instance_of(Hash)
            expect(value[0].keys).to match_array([:toto, :tutu])
            expect(value[0][:toto]).to be :hoge
            expect(value[0][:tutu]).to be :piyo
            expect(value[1]).to be_an_instance_of(Hash)
            expect(value[1].keys).to match_array([:toto, :tutu])
            expect(value[1][:toto]).to be :bla
            expect(value[1][:tutu]).to be :bla
          end
        end
      end

      context 'and the value is an Array of mixed types' do
        context 'and no block is passed' do
          subject { gleaner.o :xyzzy }

          it "returns a Hash that contains the key and an Array that " \
             "contains values except for Hashs as its value" do
            expect(subject).to have_key(:xyzzy)

            value = subject[:xyzzy]
            expect(value).to be_an_instance_of(Array)
            expect(value.size).to be 1
            expect(value.first).to be_an_instance_of(Array)
            expect(value.first.size).to be 3
            expect(value.first[0]).to be :a
            expect(value.first[1]).to be :b
            expect(value.first[2]).to be :c
          end
        end

        context 'and a block is passed' do
          subject {
            gleaner.o :xyzzy do
              o :spam
              o :hoge do
                o :foo
              end
              o :fuge
              o :piyo do
                o :def
              end
            end
          }

          it "returns a Hash that contains the specified key" do
            expect(subject).to be_an_instance_of(Hash)
            expect(subject).to have_key(:xyzzy)
          end

          describe "its value" do
            it "is an Array as the associated value" do
              value = subject[:xyzzy]
              expect(value).to be_an_instance_of(Array)
              expect(value).not_to be_empty
            end

            it "has an Array if that is defined in a block" do
              value = subject[:xyzzy].first
              expect(value).to be_an_instance_of(Array)
              expect(value.size).to be 3
              expect(value[0]).to be :a
              expect(value[1]).to be :b
              expect(value[2]).to be :c
            end

            it "has a Hash if that is defined in a block" do
              value = subject[:xyzzy][1]
              expect(value).to be_an_instance_of(Hash)
              expect(value.keys).to match_array([:spam])
              expect(value[:spam]).to be :_

              value = subject[:xyzzy][2]
              expect(value).to be_an_instance_of(Hash)
              expect(value.keys).to match_array([:hoge, :fuge, :piyo])
              expect(value[:hoge]).to be_an_instance_of(Hash)
              expect(value[:hoge].keys).to match_array([:foo])
              expect(value[:hoge][:foo]).to be_an_instance_of(Array)
              expect(value[:hoge][:foo]).to eq [:wibble]

              expect(value[:fuge]).to be_an_instance_of(Hash)
              expect(value[:fuge]).to be_empty

              expect(value[:piyo]).to be_an_instance_of(Array)
              expect(value[:piyo].size).to be 1
              expect(value[:piyo].first).to be_an_instance_of(Hash)
              expect(value[:piyo].first.keys).to match_array([:def])
            end
          end
        end
      end
    end

    context 'when an original Hash does not have the specified key' do
      let(:original_hash) do
        {
          pee: :foo,
          kaa: :baa,
          boo: :baz,
        }
      end

      let(:gleaner) do
        described_class.new(original_hash, missing_keys)
      end

      context 'and it is in default mode' do
        subject { gleaner.o :foo }

        it "returns a blank Hash" do
          expect(subject).to be_an_instance_of(Hash)
          expect(subject).to be_empty
        end
      end

      context 'and it is in required mode' do
        before { gleaner.required }

        it "adds MissingKeys" do
          expect(missing_keys.keys).to be_empty
          gleaner.o :foo
          expect(missing_keys.keys).to match_array([:foo])
        end
      end

      context 'and it is in optional mode' do
        before { gleaner.optional }
        subject { gleaner.o :foo }

        it "returns a blank Hash" do
          expect(subject).to be_an_instance_of(Hash)
          expect(subject).to be_empty
        end
      end
    end
  end
end
