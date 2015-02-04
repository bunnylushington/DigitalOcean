defmodule DigitalOcean.Images do

  @derive [Access]
  require DigitalOcean.Macros, as: Macros

  defstruct(images: [], links: %{}, meta: %{})
  @type t :: %__MODULE__{images: [DigitalOcean.Images.Image.t],
                         links: DigitalOcean.links,
                         meta: DigitalOcean.meta}

  Macros.define_as_struct(:images, DigitalOcean.Images.Image)
  Macros.implement_enumerable(:images, DigitalOcean.Images)
  
  
  defmodule Image do
    @moduledoc """
    Digital Ocean Image Struct

    Its fields are

      * `id` [integer] - unique identifier

      * `name` [string] - human readable display string
 
      * `distribution` [string] - base distribution for the image

      * `slug` [string] - unique id string

      * `public` [boolean] - indicates if images is public or not

      * `regions` [ary of strings] - regions slugs where images is available

      * `min_disk_size` [integer] - min disk req for this image

   See the [Digital Ocean Images
   documentation](https://developers.digitalocean.com/#images) for
   further details.
   """
    @derive [Access]

    defstruct(id: nil,
              name: nil,
              distribution: nil,
              slug: nil,
              public: nil,
              regions: [],
              min_disk_size: nil)
    @type t :: %__MODULE__{id: integer,
                           name: String.t,
                           distribution: String.t,
                           slug: String.t,
                           public: boolean,
                           regions: [String.t],
                           min_disk_size: integer}
  end
end
