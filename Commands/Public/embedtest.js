const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
  EmbedBuilder,
} = require("discord.js");
const { botname } = require("../../index.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("embed-test")
    .setDescription("test  embeds"),
  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */
  execute(interaction) {
    const testEmbed = new EmbedBuilder()
      .setColor(0x0099ff)
      .setTitle("Leage Rank")
      .setAuthor({
        name: botname.user.tag,
        iconURL:
          "https://ddragon.leagueoflegends.com/cdn/12.23.1/img/profileicon/23.png",
      })
      .setURL("https://www.op.gg/summoners/euw/hoothoot4")
      .setThumbnail(
        "https://i.pinimg.com/originals/b8/3e/6f/b83e6fea403a390bd06ae17c187408e3.png"
      )
      .addFields(
        {
          name: "Ranked Solo",
          value: "Silver Z| 200 lp",
        },
        { name: "Ranked Flex", value: "Gold ||| 3 lp" }
      );

    interaction.reply({ embeds: [testEmbed] });
  },
};
