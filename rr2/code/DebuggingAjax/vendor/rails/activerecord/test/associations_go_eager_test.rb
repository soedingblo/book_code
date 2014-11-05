#---
# Excerpted from "Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rr2 for more book information.
#---
require 'abstract_unit'
require 'fixtures/post'
require 'fixtures/comment'
require 'fixtures/author'
require 'fixtures/category'
require 'fixtures/company'
require 'fixtures/person'
require 'fixtures/reader'

class EagerAssociationTest < Test::Unit::TestCase
  fixtures :posts, :comments, :authors, :categories, :categories_posts,
            :companies, :accounts, :tags, :people, :readers

  def test_loading_with_one_association
    posts = Post.find(:all, :include => :comments)
    post = posts.find { |p| p.id == 1 }
    assert_equal 2, post.comments.size
    assert post.comments.include?(comments(:greetings))

    post = Post.find(:first, :include => :comments, :conditions => "posts.title = 'Welcome to the weblog'")
    assert_equal 2, post.comments.size
    assert post.comments.include?(comments(:greetings))
  end

  def test_loading_conditions_with_or
    posts = authors(:david).posts.find(:all, :include => :comments, :conditions => "comments.body like 'Normal%' OR comments.#{QUOTED_TYPE} = 'SpecialComment'")
    assert_nil posts.detect { |p| p.author_id != authors(:david).id },
      "expected to find only david's posts"
  end

  def test_with_ordering
    list = Post.find(:all, :include => :comments, :order => "posts.id DESC")
    [:eager_other, :sti_habtm, :sti_post_and_comments, :sti_comments,
     :authorless, :thinking, :welcome
    ].each_with_index do |post, index|
      assert_equal posts(post), list[index]
    end
  end

  def test_loading_with_multiple_associations
    posts = Post.find(:all, :include => [ :comments, :author, :categories ], :order => "posts.id")
    assert_equal 2, posts.first.comments.size
    assert_equal 2, posts.first.categories.size
    assert posts.first.comments.include?(comments(:greetings))
  end

  def test_loading_from_an_association
    posts = authors(:david).posts.find(:all, :include => :comments, :order => "posts.id")
    assert_equal 2, posts.first.comments.size
  end

  def test_loading_with_no_associations
    assert_nil Post.find(posts(:authorless).id, :include => :author).author
  end

  def test_eager_association_loading_with_belongs_to
    comments = Comment.find(:all, :include => :post)
    assert_equal 10, comments.length
    titles = comments.map { |c| c.post.title }
    assert titles.include?(posts(:welcome).title)
    assert titles.include?(posts(:sti_post_and_comments).title)
  end
  
  def test_eager_association_loading_with_belongs_to_and_limit
    comments = Comment.find(:all, :include => :post, :limit => 5, :order => 'comments.id')
    assert_equal 5, comments.length
    assert_equal [1,2,3,5,6], comments.collect { |c| c.id }
  end

  def test_eager_association_loading_with_belongs_to_and_limit_and_conditions
    comments = Comment.find(:all, :include => :post, :conditions => 'post_id = 4', :limit => 3, :order => 'comments.id')
    assert_equal 3, comments.length
    assert_equal [5,6,7], comments.collect { |c| c.id }
  end

  def test_eager_association_loading_with_belongs_to_and_limit_and_offset
    comments = Comment.find(:all, :include => :post, :limit => 3, :offset => 2, :order => 'comments.id')
    assert_equal 3, comments.length
    assert_equal [3,5,6], comments.collect { |c| c.id }
  end

  def test_eager_association_loading_with_belongs_to_and_limit_and_offset_and_conditions
    comments = Comment.find(:all, :include => :post, :conditions => 'post_id = 4', :limit => 3, :offset => 1, :order => 'comments.id')
    assert_equal 3, comments.length
    assert_equal [6,7,8], comments.collect { |c| c.id }
  end
  
  def test_eager_association_loading_with_belongs_to_and_limit_and_offset_and_conditions_array
    comments = Comment.find(:all, :include => :post, :conditions => ['post_id = ?',4], :limit => 3, :offset => 1, :order => 'comments.id')
    assert_equal 3, comments.length
    assert_equal [6,7,8], comments.collect { |c| c.id }
  end

  def test_eager_association_loading_with_belongs_to_and_limit_and_multiple_associations
    posts = Post.find(:all, :include => [:author, :very_special_comment], :limit => 1, :order => 'posts.id')
    assert_equal 1, posts.length
    assert_equal [1], posts.collect { |p| p.id }
  end
  
  def test_eager_association_loading_with_belongs_to_and_limit_and_offset_and_multiple_associations
    posts = Post.find(:all, :include => [:author, :very_special_comment], :limit => 1, :offset => 1, :order => 'posts.id')
    assert_equal 1, posts.length
    assert_equal [2], posts.collect { |p| p.id }
  end
  
  def test_eager_with_has_many_through
    posts_with_comments = people(:michael).posts.find(:all, :include => :comments )
    posts_with_author = people(:michael).posts.find(:all, :include => :author )
    posts_with_comments_and_author = people(:michael).posts.find(:all, :include => [ :comments, :author ])
    assert_equal 2, posts_with_comments.inject(0) { |sum, post| sum += post.comments.size }
    assert_equal authors(:david), assert_no_queries { posts_with_author.first.author }
    assert_equal authors(:david), assert_no_queries { posts_with_comments_and_author.first.author }
  end

  def test_eager_with_has_many_and_limit
    posts = Post.find(:all, :order => 'posts.id asc', :include => [ :author, :comments ], :limit => 2)
    assert_equal 2, posts.size
    assert_equal 3, posts.inject(0) { |sum, post| sum += post.comments.size }
  end

  def test_eager_with_has_many_and_limit_and_conditions
    posts = Post.find(:all, :include => [ :author, :comments ], :limit => 2, :conditions => "posts.body = 'hello'", :order => "posts.id")
    assert_equal 2, posts.size
    assert_equal [4,5], posts.collect { |p| p.id }
  end

  def test_eager_with_has_many_and_limit_and_conditions_array
    posts = Post.find(:all, :include => [ :author, :comments ], :limit => 2, :conditions => [ "posts.body = ?", 'hello' ], :order => "posts.id")
    assert_equal 2, posts.size
    assert_equal [4,5], posts.collect { |p| p.id }    
  end

  def test_eager_with_has_many_and_limit_and_conditions_array_on_the_eagers
    posts = Post.find(:all, :include => [ :author, :comments ], :limit => 2, :conditions => [ "authors.name = ?", 'David' ])
    assert_equal 2, posts.size
    
    count = Post.count(:include => [ :author, :comments ], :limit => 2, :conditions => [ "authors.name = ?", 'David' ])
    assert_equal count, posts.size
  end

  def test_eager_with_has_many_and_limit_ond_high_offset
    posts = Post.find(:all, :include => [ :author, :comments ], :limit => 2, :offset => 10, :conditions => [ "authors.name = ?", 'David' ])
    assert_equal 0, posts.size
  end

  def test_count_eager_with_has_many_and_limit_ond_high_offset
    posts = Post.count(:all, :include => [ :author, :comments ], :limit => 2, :offset => 10, :conditions => [ "authors.name = ?", 'David' ])
    assert_equal 0, posts
  end

  def test_eager_with_has_many_and_limit_with_no_results
    posts = Post.find(:all, :include => [ :author, :comments ], :limit => 2, :conditions => "posts.title = 'magic forest'")
    assert_equal 0, posts.size
  end

  def test_eager_with_has_and_belongs_to_many_and_limit
    posts = Post.find(:all, :include => :categories, :order => "posts.id", :limit => 3)
    assert_equal 3, posts.size
    assert_equal 2, posts[0].categories.size
    assert_equal 1, posts[1].categories.size
    assert_equal 0, posts[2].categories.size
    assert posts[0].categories.include?(categories(:technology))
    assert posts[1].categories.include?(categories(:general))
  end

  def test_eager_with_has_many_and_limit_and_conditions_on_the_eagers
    posts = authors(:david).posts.find(:all, 
      :include    => :comments, 
      :conditions => "comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment'",
      :limit      => 2
    )
    assert_equal 2, posts.size
    
    count = Post.count(
      :include    => [ :comments, :author ], 
      :conditions => "authors.name = 'David' AND (comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment')",
      :limit      => 2
    )
    assert_equal count, posts.size
  end

  def test_eager_with_has_many_and_limit_and_scoped_conditions_on_the_eagers
    posts = nil
    Post.with_scope(:find => {
      :include    => :comments, 
      :conditions => "comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment'"
    }) do
      posts = authors(:david).posts.find(:all, :limit => 2)
      assert_equal 2, posts.size
    end
    
    Post.with_scope(:find => {
      :include    => [ :comments, :author ], 
      :conditions => "authors.name = 'David' AND (comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment')"
    }) do
      count = Post.count(:limit => 2)
      assert_equal count, posts.size
    end
  end

  def test_eager_with_has_many_and_limit_and_scoped_and_explicit_conditions_on_the_eagers
    Post.with_scope(:find => { :conditions => "1=1" }) do
      posts = authors(:david).posts.find(:all, 
        :include    => :comments, 
        :conditions => "comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment'",
        :limit      => 2
      )
      assert_equal 2, posts.size
      
      count = Post.count(
        :include    => [ :comments, :author ], 
        :conditions => "authors.name = 'David' AND (comments.body like 'Normal%' OR comments.#{QUOTED_TYPE}= 'SpecialComment')",
        :limit      => 2
      )
      assert_equal count, posts.size
    end
  end
  def test_eager_association_loading_with_habtm
    posts = Post.find(:all, :include => :categories, :order => "posts.id")
    assert_equal 2, posts[0].categories.size
    assert_equal 1, posts[1].categories.size
    assert_equal 0, posts[2].categories.size
    assert posts[0].categories.include?(categories(:technology))
    assert posts[1].categories.include?(categories(:general))
  end

  def test_eager_with_inheritance
    posts = SpecialPost.find(:all, :include => [ :comments ])
  end

  def test_eager_has_one_with_association_inheritance
    post = Post.find(4, :include => [ :very_special_comment ])
    assert_equal "VerySpecialComment", post.very_special_comment.class.to_s
  end

  def test_eager_has_many_with_association_inheritance
    post = Post.find(4, :include => [ :special_comments ])
    post.special_comments.each do |special_comment|
      assert_equal "SpecialComment", special_comment.class.to_s
    end
  end

  def test_eager_habtm_with_association_inheritance
    post = Post.find(6, :include => [ :special_categories ])
    assert_equal 1, post.special_categories.size
    post.special_categories.each do |special_category|
      assert_equal "SpecialCategory", special_category.class.to_s
    end
  end

  def test_eager_with_has_one_dependent_does_not_destroy_dependent
    assert_not_nil companies(:first_firm).account
    f = Firm.find(:first, :include => :account,
            :conditions => ["companies.name = ?", "37signals"])
    assert_not_nil f.account
    assert_equal companies(:first_firm, :reload).account, f.account
  end

  def test_eager_with_invalid_association_reference
    assert_raises(ActiveRecord::ConfigurationError, "Association was not found; perhaps you misspelled it?  You specified :include => :monkeys") {
      post = Post.find(6, :include=> :monkeys )
    }
    assert_raises(ActiveRecord::ConfigurationError, "Association was not found; perhaps you misspelled it?  You specified :include => :monkeys") {
      post = Post.find(6, :include=>[ :monkeys ])
    }
    assert_raises(ActiveRecord::ConfigurationError, "Association was not found; perhaps you misspelled it?  You specified :include => :monkeys") {
      post = Post.find(6, :include=>[ 'monkeys' ])
    }
    assert_raises(ActiveRecord::ConfigurationError, "Association was not found; perhaps you misspelled it?  You specified :include => :monkeys, :elephants") {
      post = Post.find(6, :include=>[ :monkeys, :elephants ])
    }
  end
  
  def find_all_ordered(className, include=nil)
    className.find(:all, :order=>"#{className.table_name}.#{className.primary_key}", :include=>include)
  end

  def test_eager_with_multiple_associations_with_same_table_has_many_and_habtm
    # Eager includes of has many and habtm associations aren't necessarily sorted in the same way
    def assert_equal_after_sort(item1, item2, item3 = nil)
      assert_equal(item1.sort{|a,b| a.id <=> b.id}, item2.sort{|a,b| a.id <=> b.id})
      assert_equal(item3.sort{|a,b| a.id <=> b.id}, item2.sort{|a,b| a.id <=> b.id}) if item3
    end
    # Test regular association, association with conditions, association with
    # STI, and association with conditions assured not to be true
    post_types = [:posts, :hello_posts, :special_posts, :nonexistent_posts]
    # test both has_many and has_and_belongs_to_many
    [Author, Category].each do |className|
      d1 = find_all_ordered(className)
      # test including all post types at once
      d2 = find_all_ordered(className, post_types) 
      d1.each_index do |i| 
        assert_equal(d1[i], d2[i])
        assert_equal_after_sort(d1[i].posts, d2[i].posts)
        post_types[1..-1].each do |post_type|
          # test including post_types together
          d3 = find_all_ordered(className, [:posts, post_type])
          assert_equal(d1[i], d3[i])
          assert_equal_after_sort(d1[i].posts, d3[i].posts)
          assert_equal_after_sort(d1[i].send(post_type), d2[i].send(post_type), d3[i].send(post_type))
        end
      end
    end
  end
  
  def test_eager_with_multiple_associations_with_same_table_has_one
    d1 = find_all_ordered(Firm)
    d2 = find_all_ordered(Firm, :account)
    d1.each_index do |i| 
      assert_equal(d1[i], d2[i])
      assert_equal(d1[i].account, d2[i].account)
    end
  end
  
  def test_eager_with_multiple_associations_with_same_table_belongs_to
    firm_types = [:firm, :firm_with_basic_id, :firm_with_other_name, :firm_with_condition]
    d1 = find_all_ordered(Client)
    d2 = find_all_ordered(Client, firm_types)
    d1.each_index do |i| 
      assert_equal(d1[i], d2[i])
      firm_types.each { |type| assert_equal(d1[i].send(type), d2[i].send(type)) }
    end
  end
  def test_eager_with_valid_association_as_string_not_symbol
    assert_nothing_raised { Post.find(:all, :include => 'comments') }
  end

  def test_preconfigured_includes_with_belongs_to
    author = posts(:welcome).author_with_posts
    assert_equal 5, author.posts.size
  end

  def test_preconfigured_includes_with_has_one
    comment = posts(:sti_comments).very_special_comment_with_post
    assert_equal posts(:sti_comments), comment.post
  end

  def test_preconfigured_includes_with_has_many
    posts = authors(:david).posts_with_comments
    one = posts.detect { |p| p.id == 1 }
    assert_equal 5, posts.size
    assert_equal 2, one.comments.size
  end

  def test_preconfigured_includes_with_habtm
    posts = authors(:david).posts_with_categories
    one = posts.detect { |p| p.id == 1 }
    assert_equal 5, posts.size
    assert_equal 2, one.categories.size
  end

  def test_preconfigured_includes_with_has_many_and_habtm
    posts = authors(:david).posts_with_comments_and_categories
    one = posts.detect { |p| p.id == 1 }
    assert_equal 5, posts.size
    assert_equal 2, one.comments.size
    assert_equal 2, one.categories.size
  end
end