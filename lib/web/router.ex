defmodule Web.Router do
  use ArcaneAssistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Web.Components.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser

    live "/", Live.NPCs.Index, :index
    live "/npcs", Live.NPCs.Index, :index
    live "/npcs/new", Live.NPCs.Index, :new
    live "/npcs/:id/edit", Live.NPCs.Index, :edit

    live "/npcs/:id", Live.NPCs.Show, :show
    live "/npcs/:id/show/edit", Live.NPCs.Show, :edit

    live "/quests", Live.Quests.Index, :index
    live "/quests/new", Live.Quests.Index, :new
    live "/quests/:id/edit", Live.Quests.Index, :edit

    live "/quests/:id", Live.Quests.Show, :show
    live "/quests/:id/show/edit", Live.Quests.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:arcane_assist, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
