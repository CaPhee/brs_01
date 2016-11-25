module ApplicationHelper
  def show_avatar user, avatar_size
    link_to image_tag(user.avatar, alt: user.name, size: avatar_size,
      class: "avatar"), user
  end

  def show_cover book
    link_to image_tag(book.cover, alt: book.title, size: Settings.size_of_book_cover,
      class: "book-cover"), book
  end

  def show_book_introduce book
    truncate strip_tags(book.introduce),
      length: Settings.length_sub_introduce, separator: " "
  end

  def show_book_title book
    link_to truncate(strip_tags(book.title),
      length: Settings.length_sub_title, separator: " "), book
  end

  def active_class link_path
    request.original_fullpath.include?(link_path) ? "active" : ""
  end

  def get_action activity
    case activity.action_type.to_i
    when Activity.activity_types[:created]
      case activity.target_type
      when User.name
        t :follow_action, user: activity.user.name, action: t(:follow),
          followed: link_to(activity.followed.name, activity.followed)
      when Book.name
        t :mark, user: activity.user.name, book: show_book_title(activity.book),
          mark_type: t(:favorite)
      when Review.name
        t :write, user: activity.user.name,
          target: show_book_title(activity.review.book), post_type: t(:review),
          post: truncate(activity.review.title, length_sub_title, separator: " ")
      when Comment.name
        t :write, user: activity.user.name, post: "",
          target: show_book_title(activity.comment.title), post_type: t(:comment)
      end
    when Activity.activity_types[:updated]
      if activity.target_type == Book.name
        t :mark, user: activity.user.name, book: show_book_title(activity.book),
          mark_type: t(:reaing)
      end
    when Activity.activity_types[:removed]
      if activity.target_type == Book.name
        t :mark, user: activity.user.name, book: show_book_title(activity.book),
          mark_type: t(:read)
      end
      if activity.target_type == User.name
        t :follow_action, user: activity.user.name, action: t(:unfollow),
          followed: link_to(activity.followed.name, activity.followed)
      end
    else
      t :error
    end
  end
end
