const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
} = require("discord.js");

const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

module.exports = {
  data: new SlashCommandBuilder()
    .setName("chess-info")
    .setDescription("get chess info")
    .addStringOption((option) =>
      option
        .setName("game-mode")
        .setDescription("Choose mode")
        .setRequired(true)
        .addChoices(
          { name: "Bullet", value: "chess_bullet" },
          { name: "Blitz", value: "chess_blitz" },
          { name: "Rapid", value: "chess_rapid" }
        )
    )
    .addStringOption((option) =>
      option
        .setName("username")
        .setDescription("Enter your chess.com username")
        .setRequired(true)
    ),
  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */
  async execute(interaction) {
    const chess_username = interaction.options.getString("username");
    const mode = interaction.options.getString("game-mode");
    let chess_url = `https://api.chess.com/pub/player/${chess_username}/stats`;
    console.log(mode);
    const mode_txt = mode.split("_").pop();

    try {
      const chess_info = await fetch(chess_url)
        .then((resp) => resp.json())
        .then((resp) => {
          return resp;
        });

      const rating = chess_info[mode].last.rating;

      console.log(rating);

      interaction.reply({
        content: `${chess_username}'s ${mode_txt} rating is: ${rating}`,
        ephemeral: false,
      });
    } catch (error) {
      interaction.reply({
        content: `Der var en fejl. Prøv igen senere.`,
        ephemeral: true,
      });
    }
  },
};
