local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("mRadial", "esES");
if not L then return end

L["Opt_GenericOptions_name"] = "Opciones Genéricas"
L["Opt_GenericOptions_desc"] = "Estas se aplican a toda la interfaz de usuario"

L["Opt_ConfigMode_name"] = "Modo de Configuración"
L["Opt_ConfigMode_desc"] = "Habilita/deshabilita el modo de configuración."

L["Opt_HideOutOfCombat_name"] = "Ocultar Fuera de Combate"
L["Opt_HideOutOfCombat_desc"] = "Habilita/deshabilita ocultar la interfaz de usuario mientras está fuera de combate."

L["Opt_HideMiniMapIcon_name"] = "Ocultar Icono del Minimapa"
L["Opt_HideMiniMapIcon_desc"] = "Habilita/deshabilita el icono del minimapa a favor del nuevo contenedor del complemento. Este cambio tendrá efecto en la próxima recarga/inicio de sesión."

L["Opt_ABOUT_name"] = "ACERCA DE"
L["Opt_ABOUT_desc"] = "Bienvenido a mRadial, una pequeña interfaz de usuario para rastrear temporizadores de hechizos, etc. \
\nTienes un marco radial primario y secundario para asignar los hechizos a observar. También puedes configurarlos como botones clicables si así lo deseas. \
\n¿Por qué escribí esto? Bueno, me gusta mantener mi enfoque en mi personaje tanto como sea posible, y este complemento ayuda a mantener los hechizos más importantes que quiero rastrear en \
un círculo ajustado alrededor del personaje (¡así que no me quedo parado en el fuego, vale!) \
\nPara obtener más información, visita la wiki a través de CurseForge. \
\n \n"

L["Opt_CHANGELOG_name"] = "REGISTRO DE CAMBIOS"

L["Opt_RadialIcons_name"] = "Iconos Radiales"
L["Opt_RadialIcons_desc"] = "Utilízalo para cambiar los iconos de los hechizos y los diversos temporizadores de texto."

L["Opt_BaseIconOptions_name"] = "Opciones de Icono Base"
L["Opt_BaseIconOptions_desc"] = "Utiliza estas opciones para afectar la visualización de los iconos de 'vigilante'."

L["Opt_general_name"] = "General"

L["Opt_AutoSpread_name"] = "Distribución Automática"
L["Opt_AutoSpread_desc"] = "Habilita/deshabilita la distribución automática alrededor del marco radial."

L["Opt_AsButtons_name"] = "Como Botones"
L["Opt_AsButtons_desc"] = "Habilita/deshabilita los iconos como botones. \n Requiere reinicio. \n POR DEFECTO: Falso"

L["Opt_HideSecondary_name"] = "Ocultar secundarios"
L["Opt_HideSecondary_desc"] = "Permite activar/desactivar iconos secundarios. POR DEFECTO: Falso"

L["Opt_Dimensions_name"] = "Dimensiones"

L["Opt_RadiusMultiplyer_name"] = "Multiplicador de Radio"
L["Opt_RadiusMultiplyer_desc"] = "Utilízalo para aplicar un cambio global al tamaño del radio. POR DEFECTO: %100."

L["Opt_Dimensions_CenterBelow_name"] = "CentrarTemporizadorAbajo"
L["Opt_Dimensions_CenterBelow_desc"] = "Coloca los temporizadores directamente debajo o encima cuando los iconos están en la región central."

L["Opt_SpellIconSize_name"] = "Tamaño del Icono de Hechizo"
L["Opt_SpellIconSize_desc"] = "Utilízalo para cambiar el tamaño de los iconos de los hechizos. POR DEFECTO: 40"

L["Opt_Primary_name"] = "Primario"

L["Opt_Radius_name"] = "Radio"
L["Opt_Radius_desc"] = "Utilízalo para cambiar el tamaño (radio) del círculo. POR DEFECTO: 50"

L["Opt_Spread_name"] = "Distribución"
L["Opt_Spread_desc"] = "Utilízalo para cambiar la distribución de los iconos de los hechizos alrededor del círculo."

L["Opt_Offset_name"] = "Desplazamiento"
L["Opt_Offset_desc"] = "Utilízalo para desplazar la ubicación de inicio de los iconos de los hechizos alrededor del círculo. POR DEFECTO: 0.7"

L["Opt_WidthAdjust_name"] = "Ajuste de Ancho"
L["Opt_WidthAdjust_desc"] = "Utilízalo para ajustar el ancho del círculo. Esto creará una forma ovalada horizontalmente. POR DEFECTO: 1"

L["Opt_HeightAdjust_name"] = "Ajuste de Altura"
L["Opt_HeightAdjust_desc"] = "Utilízalo para ajustar la altura del círculo. Esto creará una forma ovalada verticalmente. POR DEFECTO: 1"

L["Opt_Text_name"] = "Texto/Fuentes"

L["Opt_Font_name"] = "Fuente"

L["Opt_HeightAdjust_name"] = "Ajuste de Altura"
L["Opt_HeightAdjust_desc"] = "Utilízalo para ajustar la altura del círculo. Esto creará una forma ovalada verticalmente. POR DEFECTO: 1"

L["Opt_GlobalFont%_name"] = "Tamaño de Fuente Global %"
L["Opt_GlobalFont%_desc"] = "Esto controla el tamaño de fuente general para la interfaz de usuario. Un valor del 50% será el 50% del tamaño actual del icono. POR DEFECTO: %50"

L["Opt_FontSizeOverrides_name"] = "Sobrescrituras de Tamaño de Fuente"

L["Opt_count_name"] = "Conteo"
L["Opt_ready_name"] = "Listo"
L["Opt_CoolDown_name"] = "Tiempo de Enfriamiento"
L["Opt_timer_name"] = "Temporizador"
L["Opt_linked_name"] = "Vinculado"
L["Opt_fontAdjustWarning_name"] = "--- Activa el Modo de Configuración al Ajustar los Parámetros Siguientes ---"

L["Opt_DEFAULT2_desc"] = "POR DEFECTO: 2"

L["Opt_radialSpells_desc"] = "Hechizos Radiales"

L["Opt_fagDesc_desc"] = "--Utilízalo para seleccionar los hechizos que se mostrarán en los marcos radiales primario y secundario.--"

L["Opt_hidePassiveSpells_name"] = "Ocultar Hechizos Pasivos"

L["Opt_primarySpellOrder_name"] = "Orden de Hechizos Primarios"
L["Opt_primarySpells_name"] = "Hechizos Primarios"
L["Opt_secondarySpellOrder_name"] = "Orden de Hechizos Secundarios"
L["Opt_secondarySpells_name"] = "Hechizos Secundarios"

L["Opt_linkedSpells_name"] = "Hechizos Vinculados"

L["Opt_warlock_name"] = "Brujo"

L["Opt_PetFrames_name"] = "Marcos de Mascota"
L["Opt_HidePetFrames_name"] = "Ocultar Marcos de Mascota"
L["Opt_HidePetFrames_desc"] = "Mostrar/Ocultar los marcos de mascota del brujo."

L["Opt_IconSize_name"] = "Tamaño del Icono"
L["Opt_IconSize_desc"] = "Utilízalo para cambiar el tamaño de los iconos de los hechizos."

L["Opt_ShardFrames_name"] = "Marcos de Fragmentos"

L["Opt_OutOfShardsFrameSize_name"] = "Tamaño del Marco Sin Fragmentos"
L["Opt_OutOfShardsFrameSize_desc"] = "Utilízalo para cambiar el marco que muestra el círculo de 'sin fragmentos'. ¡Activa el modo de configuración para esto!"

L["Opt_ShardTrackerFrameSize_name"] = "Tamaño del Marco de Rastreador de Fragmentos"
L["Opt_ShardTrackerFrameSize_desc"] = "Utilízalo para cambiar el marco que muestra el rastreador personalizado de fragmentos."

L["Opt_ShardTrackerTrans_name"] = "Transparencia del Marco de Fragmentos"
L["Opt_ShardTrackerTrans_desc"] = "Utilízalo para cambiar la transparencia del marco de fragmentos. Activa el modo de configuración para esto."

L["Opt_HideShardTracker_name"] = "Ocultar Marco de Fragmentos"
L["Opt_HideShardTracker_desc"] = "Mostrar/Ocultar el marco de rastreo de fragmentos del brujo."

L["Opt_RDY_name"] = "RDY"
L["Opt_NOSSSTR_name"] = "X"
L["Opt_OOR_name"] = "OOR"

L["Opt_LinkedSpellsInfo_name"] = "Los hechizos vinculados son una forma de vincular un beneficio a un hechizo principal. \
\n ej: Vincular DemonBolt a Demonic Core iniciará un temporizador junto a DemonBolt cuando DC se active, lo que permitirá sincronizar los lanzamientos, etc. \
\n Cómo hacerlo: \
\n Arrastra y suelta un hechizo del libro de hechizos en el campo de entrada de la mano izquierda. Escribe el nombre del hechizo (o arrástralo) en el campo de hechizo vinculado. El ID del hechizo se debería rellenar automáticamente. \
\n Nota: Los nombres de los hechizos de origen son únicos y solo se pueden vincular una vez."

L["Opt_LinkedSpellsLinkedTo_name"] = "vinculado a:"
L["Opt_LinkedSpellsRemove_name"] = "Eliminar"
L["Opt_LinkedSpellsPane_name"] = "Hechizo vinculado (Beneficios): "
L["Opt_LinkedSpellsAdd_name"] = "Agregar"
L["Opt_LinkedSpellsGrp_name"] = "Hechizos Vinculados"

L["Opt_Felguard"] = " Guardia vil"
L["Opt_Wrathguard"] = "Guardia de la Ira"
L["Opt_DemonicStrength"] = "Fuerza demoníaca"
L["Opt_FelStorm"] = "Tormenta vil"
L["Opt_AxeToss"] = "AxtwurfLanzamiento de hacha"
L["Opt_SoulStrike"] = "Golpe de alma"
L["Opt_Succubus"] = "Súcubo"
L["Opt_Incubus"] = "Íncubo"

L["Opt_Size"] = "Größe"

L["SummonSoulKeeperSpellname"] = "Invocar guardianalmas"
L["ShadowFurySpellname"] = "Furia de las Sombras"
