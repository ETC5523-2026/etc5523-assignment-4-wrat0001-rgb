library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(victransport)

# Load bundled package data
data("patronage", package = "victransport")

# User interface
ui <- page_sidebar(
  title = "Victorian Public Transport Explorer",

  sidebar = sidebar(
    title = "Explore patronage",

    selectInput(
      "mode",
      "Transport mode",
      choices = sort(unique(patronage$mode)),
      selected = "Metropolitan train"
    ),

    selectInput(
      "day_type",
      "Day type",
      choices = c("All", sort(unique(patronage$day_type))),
      selected = "All"
    ),

    sliderInput(
      "years",
      "Reporting years",
      min = min(patronage$year),
      max = max(patronage$year),
      value = range(patronage$year),
      step = 1,
      sep = ""
    ),

    helpText(
      "Patronage represents reported average daily passenger use,",
      "not total monthly passenger journeys."
    )
  ),

  layout_columns(
    value_box(
      title = "Mean of reported daily averages",
      value = textOutput("mean_patronage")
    ),

    value_box(
      title = "Reporting months",
      value = textOutput("months_shown")
    )
  ),

  
navset_card_tab(
  nav_panel(
    "Trend over time",
    plotOutput("trend_plot", height = "450px")
  ),

  nav_panel(
    "Day-of-week comparison",
    plotOutput("weekday_plot", height = "450px")
  ),

  nav_panel(
    "Compare transport modes",
    p(
      "Compare all five transport modes using the selected",
      "reporting years and day type. The transport mode filter",
      "does not apply to this comparison."
    ),
    plotOutput("mode_plot", height = "450px")
  )
)

)

# Server
server <- function(input, output, session) {

  # Shared filtered data for the selected transport mode
  filtered_data <- reactive({
    data <- patronage |>
      filter(
        mode == input$mode,
        year >= input$years[1],
        year <= input$years[2]
      )

    if (input$day_type != "All") {
      data <- data |>
        filter(day_type == input$day_type)
    }

    data
  })
  
  # Filter by reporting years and day type, keeping all modes
  mode_comparison_data <- reactive({
    data <- patronage |>
      filter(
        year >= input$years[1],
        year <= input$years[2]
      )

    if (input$day_type != "All") {
      data <- data |>
        filter(day_type == input$day_type)
    }

    data
  })

  # Summary function from the victransport package
  weekday_summary <- reactive({
    summarise_daily_patronage(
      data = filtered_data()
    )
  })

  output$mean_patronage <- renderText({
    data <- filtered_data()

    validate(
      need(nrow(data) > 0, "No observations match your filters.")
    )

    format(
      round(mean(data$avg_daily_patronage)),
      big.mark = ","
    )
  })

  output$months_shown <- renderText({
    data <- filtered_data()

    validate(
      need(nrow(data) > 0, "No observations match your filters.")
    )

    dplyr::n_distinct(data$date)
  })

  output$trend_plot <- renderPlot({
    data <- filtered_data()

    validate(
      need(nrow(data) > 0, "No observations match your filters.")
    )

    monthly <- data |>
      group_by(date, day_type) |>
      summarise(
        mean_patronage = mean(avg_daily_patronage),
        .groups = "drop"
      )

    ggplot(
      monthly,
      aes(
        x = date,
        y = mean_patronage,
        colour = day_type
      )
    ) +
      geom_line(linewidth = 0.8) +
      labs(
        title = "Average daily patronage over time",
        x = "Reporting month",
        y = "Mean reported daily patronage",
        colour = "Day type"
      ) +
      scale_y_continuous(
        labels = scales::label_comma()
      ) +
      theme_minimal(base_size = 12)
  })

  output$weekday_plot <- renderPlot({
    data <- weekday_summary()

    validate(
      need(nrow(data) > 0, "No observations match your filters.")
    )

    
ggplot(
  data,
  aes(
    x = day_of_week,
    y = mean_daily_patronage,
    fill = day_type
  )
) +
  geom_col(width = 0.7) +
  facet_wrap(
    ~ day_type,
    scales = "free_x"
  ) +
  scale_y_continuous(
    labels = scales::label_comma()
  ) +
  labs(
    title = "How does patronage vary across the week?",
    subtitle = "Unweighted mean of reported daily averages",
    x = NULL,
    y = "Mean of reported daily averages"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    strip.text = element_text(face = "bold"),
    axis.text.x = element_text(angle = 30, hjust = 1),
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )
})
  

  # Compare mean reported daily patronage across transport modes
  output$mode_plot <- renderPlot({
    data <- mode_comparison_data()

    validate(
      need(nrow(data) > 0, "No observations match your filters.")
    )

    mode_summary <- data |>
      group_by(mode) |>
      summarise(
        mean_daily_patronage = mean(
          avg_daily_patronage,
          na.rm = TRUE
        ),
        n_observations = n(),
        .groups = "drop"
      ) |>
      arrange(mean_daily_patronage)

    ggplot(
      mode_summary,
      aes(
        x = reorder(mode, mean_daily_patronage),
        y = mean_daily_patronage
      )
    ) +
      geom_col(
        fill = "#2878B5",
        width = 0.65
      ) +
      geom_text(
        aes(
          label = scales::comma(
            round(mean_daily_patronage)
          )
        ),
        hjust = -0.1,
        size = 3.8
      ) +
      coord_flip() +
      scale_y_continuous(
        labels = scales::label_comma(),
        expand = expansion(mult = c(0, 0.2))
      ) +
      labs(
        title = "Which transport modes have higher patronage?",
        subtitle = "Unweighted mean of reported daily averages",
        x = NULL,
        y = "Mean daily patronage"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
      )
  })

  }

shinyApp(ui, server)
  